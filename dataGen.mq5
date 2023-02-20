//+------------------------------------------------------------------+
//|                                                      dataGen.mq5 |
//|                                Copyright 2023, Algorithmic, GMBH |
//|                                      https://www.algorithmic.one |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Algorithmic, GMBH"
#property link      "https://www.algorithmic.one"
#property version   "1.00"

// These are the Input parameters for the file data.csv to be created

// Input parameters for the file
// Parametros de entrada para un archivo
input string         nombre_archivo = "data.csv";  // name of the Achive to be generated
input int            num_data_to_save = 10;        // Amount of data to store
input int            candles_to_close_op = 2;      // Number of candles before we closes the operation 

// File handler
int fp = 0;

// String to write
string data = "";

// Array velas
MqlRates candles[];

// EMA handler and array
int ema_h;
double ema[];

// RSI handler and array
int rsi_h;
double rsi[];

// MACD handler and array (SIGNAL as well)
int macd_h;
double macd[];
double signal[];

// To check if the operation is successfully
bool op_abierta = false;
int velas = 0;
double price_open = 0;
enum op_types  // constant enumeration
{ SELL, BUY };

op_types last_operation;

// Function to know if there is a BUY cross
bool buy_cross() { return signal[1] > macd[1] && signal[0] < macd[0]; }

// Function to know if there is a SELL cross
bool sell_cross() { return signal[1] < macd[1] && signal[0] > macd[0]; }

void OnInit() {
   // Openning the file
   fp = FileOpen(nombre_archivo, FILE_WRITE, 0, CP_ACP);
   
   // Writing the header of the file
   string file_header = "";
   for(int i = 0; i < num_data_to_save; i++)
      file_header += "EMA_"+IntegerToString(i)+",";
   
   for(int i = 0; i < num_data_to_save; i++)
      file_header += "RSI_"+IntegerToString(i)+",";
      
   for(int i = 0; i < num_data_to_save; i++)
      file_header += "MACD_"+IntegerToString(i)+",";
      
   for(int i = 0; i < num_data_to_save; i++)
      file_header += "SIGNAL_"+IntegerToString(i)+",";
      
   file_header += "EMA_ABOVE_BELOW,CROSS_TYPE,";
      
   file_header += "class";
   FileWrite(fp, file_header);

   // Handlers
   ema_h = iMA(_Symbol, _Period, 200, 0, MODE_EMA, PRICE_CLOSE);
   rsi_h = iRSI(_Symbol, _Period, 14, PRICE_CLOSE);
   macd_h = iMACD(_Symbol, _Period, 12, 26, 9, PRICE_CLOSE);
  
   
   ArraySetAsSeries(ema, true); 
   ArraySetAsSeries(rsi, true);
   ArraySetAsSeries(macd, true);
   ArraySetAsSeries(signal, true);
   ArraySetAsSeries(candles, true);
}


void OnTick() {
   // Loading information
   CopyBuffer(ema_h, 0, 0, num_data_to_save, ema);
   CopyBuffer(rsi_h, 0, 0, num_data_to_save, rsi);
   CopyBuffer(macd_h, MAIN_LINE, 0, num_data_to_save, macd);
   CopyBuffer(macd_h, SIGNAL_LINE, 0, num_data_to_save, signal);
   CopyRates(_Symbol, _Period, 0, num_data_to_save, candles);
   
   // If there is a cross we are going to save data in the file
   if ((buy_cross() || sell_cross()) && !op_abierta) {
   
      // Saving the EMA
      string ema_data = "";
      for(int i = 0; i < num_data_to_save; i++) {
         double ema_normalized = NormalizeDouble(ema[i], _Digits);
         ema_data += DoubleToString(ema_normalized)+",";
      }
      
      // Saving the RSI
      string rsi_data = "";
      for(int i = 0; i < num_data_to_save; i++) {
         double rsi_normalized = NormalizeDouble(rsi[i], _Digits);
         rsi_data += DoubleToString(rsi_normalized)+",";
      }
      
      // Saving the MACD
      string macd_data = "";
      for(int i = 0; i < num_data_to_save; i++) {
         double macd_normalized = NormalizeDouble(macd[i], _Digits);
         macd_data += DoubleToString(macd_normalized)+",";
      }
      
      // Saving the SIGNAL
      string signal_data = "";
      for(int i = 0; i < num_data_to_save; i++) {
         double signal_normalized = NormalizeDouble(signal[i], _Digits);
         signal_data += DoubleToString(signal_normalized)+",";
      }
      
      // Is the price above or below the EMA? 1 (above) 0 (below) 
      string above_below = candles[0].close >= ema[0] ? "1," : "0,";
      
      // Saving the type of the cross
      string cross_type = "";
      if (buy_cross()) {cross_type = "1,"; last_operation = BUY;}
      else if (sell_cross()) {cross_type = "0,"; last_operation = SELL;}
      
      data = ema_data+rsi_data+macd_data+signal_data+above_below+cross_type;
      
      op_abierta = true;
      velas = Bars(_Symbol, _Period);
      
      price_open = candles[0].close;
   } else if (op_abierta) {
      // Checking if we moved enough candles
      if (velas+candles_to_close_op <= Bars(_Symbol, _Period)) {
         if (last_operation == BUY) {
            if (price_open < candles[0].close) FileWrite(fp, data+"1");
            else FileWrite(fp, data+"0");
         } else if (last_operation == SELL) {
            if (price_open > candles[0].close) FileWrite(fp, data+"1");
            else FileWrite(fp, data+"0");
         }
         
         data = "";
         op_abierta = false;
      }   
   }
}

void OnDeinit(const int reason) {
   FileClose(fp);
}