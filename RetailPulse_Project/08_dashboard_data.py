import pandas as pd

Cleaned_Data = pd.read_csv(r'C:\Users\Madhumathi\Desktop\RetailPulse\01_Data\Cleaned_Data\Cleaned_Data.csv',
usecols = [
        'order_id',
        'product_id',
        'add_to_cart_order',
        'reordered',
        'user_id',
        'order_number',
        'order_dow',
        'order_hour_of_day',
        'days_since_prior_order',
        'department'
    ],

    dtype={
        'order_id': 'int32',
        'product_id': 'int32',
        'add_to_cart_order': 'int16',
        'reordered': 'int8',
        'user_id': 'int32',
        'order_number': 'int16',
        'order_dow': 'int8',
        'order_hour_of_day': 'int8',
        'days_since_prior_order': 'float32'
    }
)

print(Cleaned_Data.shape)

Cleaned_Data['predicted_churn'] = (Cleaned_Data['days_since_prior_order'] > 10).astype(int)

Cleaned_Data['customer_segment'] = 'Others'

Cleaned_Data.loc[Cleaned_Data['order_number'] >= 10,'customer_segment'] = 'Loyal Customers'

Cleaned_Data.loc[Cleaned_Data['order_number'] >= 20,'customer_segment'] = 'Champions'

dashboard_data = Cleaned_Data.sample(500000,random_state=42)

print(dashboard_data.shape)
print(dashboard_data.head())

dashboard_data.to_csv(r'C:\Users\Madhumathi\Desktop\RetailPulse\01_Data\dashboard_data.csv',index=False)

print("dashboard_data.csv saved successfully")