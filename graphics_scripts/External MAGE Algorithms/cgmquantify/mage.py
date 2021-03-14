import os
import pandas as pd
from cgmquantify import MAGE, MGE

columns = ["num", "name", "mage"]
output_df = pd.DataFrame(columns=columns)
print(output_df)

for filename in os.listdir(os.getcwd() + "/Data/"):
    print(filename, end=" ")
    # read in csv file
    df = pd.read_csv("Data/" + filename)

    data = pd.DataFrame()

    # format time, day, gl
    data['Time'] = df['timestamp'] 
    data['Time'] = pd.to_datetime(data['Time'], format='%Y-%m-%dT%H:%M')

    data['Day'] = data['Time'].dt.date

    data['Glucose'] = pd.to_numeric(df['sensorglucose'])

    mage_data = MAGE(data)
    # mge_data = MGE(data)
    # print(mage_data, mge_data)
    num = int(filename.split(".")[0][4:])

    output_df.loc[len(output_df)] = [num, filename,mage_data]


output_df.sort_values(by=['num'], inplace=True)
print(output_df)
output_df.to_csv(os.getcwd() + "/output.csv", index=False)