import pickle
import pandas as pd
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import cross_val_score

FILENAME = 'data.csv'

def fix_line(line, is_header=False):
    """Function to fix a line.
    Args:
        line (string): Line to correct.
        is_header (bool, optional): 
            To know if we are fixing the header. Defaults to False.
    Returns:
        string: 
            Corrected line.
    """
    line = line.replace('\n', '')
    line = line.replace('ÿþ', '')
    line = line.split(',')
    line = [ elem.replace('\x00', '') for elem in line ]
    if not is_header: line = [ float(elem) for elem in line ]
    return line

# Openning the file in the correct encoding
with open(FILENAME, encoding="cp1252") as f:
    lines = f.readlines()
    
    # Loading the header
    header = fix_line(lines[0], is_header=True)
    
    # Loading the data
    data = []
    for i, line in enumerate(lines[2:-1]):
        if i%2 == 0 and line != '':
            data.append(fix_line(line))

# Creating a pandas dataframe           
df = pd.DataFrame(data, columns=header)

# Correcting the class type
df[header[-1]] = df[header[-1]].astype('int32')

# Creating the neural network
dt = DecisionTreeClassifier()

# Setting the data for trainning
X = df.drop('class', axis=1)
y = df[header[-1]]

# Training the neural network
dt = dt.fit(X, y)

# Saving the model
with open("dt_model.pkl", "wb") as f:
    pickle.dump(dt, f)
    
# To load the model
# with open("nn_model.pkl", "rb") as f:
#     nn = pickle.load(f)