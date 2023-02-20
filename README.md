## AI ML - MACD, RSI, EMA BOT based on Decision Tree Neural Network

AI EA bot based on the indicators **MACD**, **RSI** and **EMA** CossOver. This EA uses a **decision tree** Neural Network based on Machine Learning in Python from https://scikit-learn.org ! 
More info --> https://www.algorithmic.one/#ai_mreb

### How To
- Install Metatrader 5
- Inside ```MT5 Options``` click  ```Allow algorithmic trading```
- Go to ```Tools```
- Click on ```Allow algorithmic trading```
- Add ```Localhost``` for Client
- Install MetaTrader 5 python - ```pip install MetaTrader5```
- Install python extension in VSCode
- Add url in MT5 ```localhost```
- Install Anaconda
- Run

### Requirements
```pip install scikit-learn```
```pip install pandas```

#### How to Setup
1. Run dataGen.ex5 to Generate the dataset data.csv with the help of dataGen based on the last 10 years by loading the ex5 with MT5 Tester and doing a backtest.
This will generate the data.csv with the last 10 years of correlated.
2. Run AI.py so the dt_model which is the decision tree pickle file is generated based on the dataset from step 1. More info on Machine Learning in Python https://scikit-learn.org !
3. Start the server AI ```python main.py```.
4. Start on MT5 the client AI_client.ex5 (add the compiled EA to MT5 Chart) that will receive orders based on AI ML using socket on defined port.
5. Done Its running.