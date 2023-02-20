## AI ML - MACD, RSI, EMA BOT based on Decision Tree Neural Network

AI EA bot based on the indicators **MACD**, **RSI** and **EMA** CossOver. 

This MT5 EA uses a **Decision Tree (DTs)** which are a non-parametric supervised learning method used for classification and regression. 
The goal is to create a model that predicts the value of a target variable by learning simple decision rules inferred from the data features. A tree can be seen as a piecewise constant approximation. 

- Ref - https://scikit-learn.org/stable/modules/tree.html#decision-treesNeural 
- Ref - Network based on Machine Learning in Python from https://scikit-learn.org ! 

![image](https://user-images.githubusercontent.com/118682909/220060164-f88f5c9a-df7f-4207-a65c-522628115b52.png)

### How To
- Install Metatrader 5
- Inside ```MT5 Options``` click  ```Allow algorithmic trading```
- Go to ```Tools```
- Click on ```Allow algorithmic trading```
- Add ```Localhost``` for Client
- Install MetaTrader 5 python - ```pip install -r requirements.txt```
- Install python extension in VSCode
- Add url in MT5 ```localhost```
- Install Anaconda
- Run

### Requirements - PIP version is 22.3.1
```pip install -r requirements.txt```

#### How to Setup
1. Run dataGen.ex5 to Generate the dataset data.csv with the help of dataGen based on the last 10 years by loading the ex5 with MT5 Tester and doing a backtest.
This will generate the data.csv with the last 10 years of correlated.
2. Run AI.py so the dt_model which is the decision tree pickle file is generated based on the dataset from step 1. More info on Machine Learning in Python https://scikit-learn.org !
3. Start the server AI ```python main.py```.

![Capture2](https://user-images.githubusercontent.com/118682909/219991837-606805c3-1529-4fc8-b040-47a2b1a1bbaf.PNG)

4. Start on MT5 the client AI_client.ex5 (add the compiled EA to MT5 Chart) that will receive orders based on AI ML using socket on defined port.

![Capture1](https://user-images.githubusercontent.com/118682909/219991884-dc71bca7-a9aa-47a2-b84a-6a87decf9281.PNG)

5. Done It's running.
