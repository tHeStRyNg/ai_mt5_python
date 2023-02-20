from bot import Bot
import MetaTrader5 as mt5


mt5.initialize()

ai_bot = Bot(1.00, 60*15, "EURUSD")

ai_bot.start()
ai_bot.wait()