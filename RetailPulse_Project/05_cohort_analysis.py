import pandas as pd
Cohort_analysis = pd.read_csv(r'C:\Users\Madhumathi\Desktop\RetailPulse\01_Data\Cleaned_Data\Cleaned_Data.csv', usecols=['user_id','order_number'], dtype={'user_id':'int32','order_number':'int16'})
print(Cohort_analysis.shape)
print(Cohort_analysis.head())
print(Cohort_analysis.columns)
Cohort_analysis['CohortGroup'] = Cohort_analysis.groupby('user_id')['order_number'].transform(min)
print(Cohort_analysis.head())
Cohort_analysis['Cohort_Index'] = Cohort_analysis['order_number'] - Cohort_analysis['CohortGroup']
print(Cohort_analysis.head())
Cohort_pivot = Cohort_analysis.pivot_table(
    index='CohortGroup',
    columns='Cohort_Index',
    values='user_id',
    aggfunc='nunique'
)
print(Cohort_pivot.head())
Retention_matrix = Cohort_pivot.divide(Cohort_pivot.iloc[:,0], axis=0)

print(Retention_matrix.head())
import seaborn as sns
import matplotlib.pyplot as plt

plt.figure(figsize=(14,8))

sns.heatmap(Retention_matrix, cmap='Blues',annot=False)

plt.title('Cohort Retention Analysis')

plt.show()

Retention_matrix.to_csv(r'C:\Users\Madhumathi\Desktop\RetailPulse\03_Python\Retention_matrix.csv', index=False)