import pandas as pd
RFM_analysis = pd.read_csv(r'C:\Users\Madhumathi\Desktop\RetailPulse\01_Data\Cleaned_Data\Cleaned_Data.csv')
print(RFM_analysis.shape)
print(RFM_analysis.head())
print(RFM_analysis.columns)
RFM_analysis = RFM_analysis.groupby('user_id').agg({
    'order_number':'max',
    'product_id':'count',
    'days_since_prior_order':'mean'
})

RFM_analysis.columns = ['Frequency', 'Monetary', 'Recency']

print(RFM_analysis.head())
print(RFM_analysis.shape)

RFM_analysis['R_score'] = pd.qcut(RFM_analysis['Recency'],4,labels=[4,3,2,1])
RFM_analysis['F_score'] = pd.qcut(RFM_analysis['Frequency'],4,labels=[1,2,3,4])
RFM_analysis['M_score'] = pd.qcut(RFM_analysis['Monetary'],4,labels=[1,2,3,4])
print(RFM_analysis.head())

RFM_analysis['RFM_score'] = (RFM_analysis['R_score'].astype(str) + RFM_analysis['F_score'].astype(str) + RFM_analysis['M_score'].astype(str))
print(RFM_analysis.head())

import numpy as np

RFM_analysis['Segment'] = np.where(RFM_analysis['RFM_score'] == '444','Champions', np.where(RFM_analysis['F_score'].astype(int)>= 3,'Loyal Customers','Others'))
print(RFM_analysis.head())

RFM_analysis['Segment'].value_counts()
print(RFM_analysis['Segment'].value_counts())

RFM_analysis.groupby('Segment')[['Frequency','Monetary','Recency']].mean()
print(RFM_analysis.groupby('Segment')[['Frequency','Monetary','Recency']].mean())

import matplotlib.pyplot as plt
segment_counts = RFM_analysis['Segment'].value_counts()
segment_counts.plot(kind='bar')

plt.title('Customer Segmentation')
plt.xlabel('Segments')
plt.ylabel('Number of Customers')

plt.show()

segment_counts.plot(kind='pie', autopct='%1.1f%%')

plt.title('Customer Segment Distribution')
plt.ylabel('')
plt.show()

RFM_analysis.to_csv(r'C:\Users\Madhumathi\Desktop\RetailPulse\03_Python\rfm_customer_segments.csv', index=False)



