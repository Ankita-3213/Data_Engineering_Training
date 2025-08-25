import pandas as pd

data = """
TransactionID,CustomerName,PurchaseDate,Amount
1,Alice,2024-07-15,250
2,Bob,15/08/2024,300
3,Charlie,,450
4,Diana,2024/09/05,500
5,Eva,2024-10-01,NaN
6,Frank,01-11-2024,600
"""

with open('raw_data.csv', 'w')as file:
    file.write(data)

# 1. Reading CSV file
df = pd.read_csv('raw_data.csv')
print(df)

# 2. Removing rows with missing values
print(df.isna())
clean = df.dropna()
print(clean)

# 3. Converting date column to yyyy-mm-dd format
clean['PurchaseDate'] = pd.to_datetime(clean['PurchaseDate'], infer_datetime_format=True, errors='coerce')
print(clean.describe())

# 4. Normalize column names to lowercase
clean.columns = (col.lower() for col in clean.columns)
print(clean.columns)
print(clean)

# 5. Save cleaned file
clean.to_csv('clean_data.csv',index=False ,header=True) 