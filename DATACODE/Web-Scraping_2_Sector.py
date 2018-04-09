
import os

from time import sleep
import random as random
import requests
import json
from bs4 import BeautifulSoup
import pandas as pd
from requests.utils import quote
from openpyxl import load_workbook

#Define a list of sectors
sector_names = [
"Financial ",
"Financial ",
"Financial ",
"Financial ",
"Consumer Staples",
"Consumer Staples",
"Consumer Staples", 
"Utilities",
"Health Care", 
"Health Care", 
"Energy",
"Information Technology",
"Information Technology",
"Consumer Discretionary",
"Consumer Discretionary",
"Consumer Discretionary",
"Consumer Discretionary",
"Industrials",
"Industrials",
"Industrials",
"Materials",
"Real Estate"
]

sub_sector_codes = [
"8e1a3832-7720-4aa1-a883-897987a07907", #Financial/Tài chính | Insurance/Bảo hiểm
"61d2ad52-fea5-4298-9ebc-6d100f6f054c", #Financial/Tài chính | Real Estate/Bất động sản
"3500df7e-dbd3-490a-b9da-ed54962eecc4", #Financial/Tài chính | Diversified Finacials/Tài chính đa dạng
"b23310bc-e476-4523-9f74-238bd3275242", #Financial/Tài chính | /Bank/Ngân hàng
"cfcc4a06-3a09-4c0a-974c-d05997a0a4c1", #Consumer Staples/Hàng tiêu dùng thiết yếu | Household & Personal Product/Đồ gia dụng và cá nhân
"a9829c67-6d18-4c8f-9391-1eb27fc6deb6", #Consumer Staples/Hàng tiêu dùng thiết yếu | Food & Staples Retailing/Bán lẻ thực phẩm và nhu yếu phẩm
"5e06796c-8e71-45c0-ab8b-ee4e58f5a0f5", #Consumer Staples/Hàng tiêu dùng thiết yếu | Food Beverage & Tobaco/Thực phẩm, đồ uống và thuốc lá
"1abdee5e-bc3a-4b2b-9b18-6bdd6af3a9d8", #Utilities/Dịch vụ tiện ích | Utilities/Dịch vụ tiện ích
"812e9b6e-3862-4e3f-8a9e-f0e21aa1b8a2", #Health Care/Chăm sóc sức khỏe | Pharmaceuticals, Biotechnology & Life Sciences/Dược phẩm, Công nghệ sinh học và Khoa học thường thức
"fd1865c5-2d0c-4840-9b8b-608041a30c7b", #Health Care/Chăm sóc sức khỏe | Health Care Equipment & Services/Dịch vụ và thiết bị chăm sóc sức khỏe
"171c6fda-7441-4be7-aee6-b5b1d9289825", #Energy/Năng lượng | Energy/Năng lượng
"c4373128-2bd8-42fe-8437-d4490ff7f6de", #Information Technology/Công nghệ thông tin | Technology Hardware & Equipment/Công nghệ phần cứng và thiết bị
"4773e4ae-0b1a-4bda-abb7-edcd453d8550", #Information Technology/Công nghệ thông tin | Software & Services/Phần mềm và dịch vụ
"47c3260b-6a9a-4705-8619-4b15f8606586", #Consumer Discretionary/Hàng tiêu dùng  | Consumer Services/Dịch vụ tiêu dùng
"b9a38145-d45d-4d88-b66a-5f07e41313b8", #Consumer Discretionary/Hàng tiêu dùng  | Consumer Retailing/Bán lẻ
"24d3f3cb-7016-4d1e-983b-e12f6a4c7c6a", #Consumer Discretionary/Hàng tiêu dùng  | Automobiles & Components/Ô tô và linh kiện
"367d66ed-3806-44ca-937d-1d7842d7f32d", #Consumer Discretionary/Hàng tiêu dùng  | Consumer Durables & Apparel/Hàng tiêu dùng và trang trí
"15a0a01a-01c8-43a3-8ba0-3533bf6661e8", #Industrials/Công nghiệp | Capital Goods/Hàng hóa chủ chốt
"19944e86-7215-4654-b9d1-2b63586453c0", #Industrials/Công nghiệp | Transportation/Vận tải
"c7ec19bb-941a-45bf-ab08-fecce953f29a", #Industrials/Công nghiệp | Commercial & Professional Services/Các dịch vụ chuyên biệt và thương mại
"28539d98-2820-48af-b1bb-44217167d4f2", #Materials/Nguyên vật liệu | Materials/Nguyên vật liệu
"d3f3f5ed-1fa1-4c0a-a4d2-53c845c4cd69"  #Real Estate/Bất động sản | Real Estate/Bất động sản
]

sub_sector_names = [
"Insurance",
"Real Estate",
"Diversified Finacials",
"Bank",
"Household & Personal Product",
"Food & Staples Retailing",
"Food Beverage & Tobaco",
"Utilities",
"Pharmaceuticals, Biotechnology & Life Sciences",
"Health Care Equipment & Services",
"Energy",
"Technology Hardware & Equipment",
"Software & Services",
"Consumer Services",
"Consumer Retailing",
"Automobiles & Components",
"Consumer Durables & Apparel",
"Capital Goods",
"Transportation",
"Commercial & Professional Services",
"Materials",
"Real Estate"
]

sheet_names = [
"Financial (1)",
"Financial (2)",
"Financial (3)",
"Financial (4)",
"Con. Staples (1)",
"Con. Staples (2)",
"Con. Staples (3)",
"Utilities (1)",
"Health Care (1)",
"Health Care (2)",
"Energy (1)",
"Infor. Tech. (1)",
"Infor. Tech. (2)",
"Con. Discre. (1)",
"Con. Discre. (2)",
"Con. Discre. (3)",
"Con. Discre. (4)",
"Industrials (1)",
"Industrials (2)",
"Industrials (3)",
"Materials (1)",
"Real Estate (1)"
]
#Set working directory
#os.chdir('C:/Users/nguye/Dropbox (Vo Tat Thang)/[0][Master]Database/(3)Library_of_Project/(99)Mics/(13)Web-scraping') # Provide the path here 
os.chdir('D:/Dropbox (Vo Tat Thang)/[0][Master]Database/(3)Library_of_Project/(99)Mics/(13)Web-scraping') # Provide the path here 

#Page URL 
url =  "https://www.hsx.vn/Modules/Listed/Web/SymbolList?"  

#Extract data by sector 
i = 1
for sector_name, sub_sector_code, sub_sector_name, sheet_name in zip(sector_names, sub_sector_codes, sub_sector_names, sheet_names):

    parms = {'_search': 'false', \
        'page': '1', \
        'pageCriteriaLength': '4', \
        'pageFieldName1': 'Code', \
        'pageFieldName2': 'Sectors', \
        'pageFieldName3': 'Sector', \
        'pageFieldName4': 'StartWith', \
        'pageFieldOperator1': 'eq', \
        'pageFieldOperator2': '', \
        'pageFieldOperator3': '', \
        'pageFieldOperator4': '', \
        'pageFieldValue1': '', \
        'pageFieldValue2': '' , \
        'pageFieldValue3': sub_sector_code, \
        'pageFieldValue4': '', \
        'rows': '400', \
        'sidx': 'id', \
        'nd' : '', \
        'sord': 'desc' 
    }

    #print(parms)

    #Request data from server (Note: must use get, post returns all values)
    response = requests.get(url = url, \
                            params = parms, \
                            headers = {'X-Requested-With': 'XMLHttpRequest' \
                                    ,  'User-Agent': 'My web scraping program. Contact me at Dinh.Nguyen.UEH@outlook.com' \
                                        }
                            )  
    print(response.request.url)

    #Convert data to html
    response_html = BeautifulSoup(response.text, "lxml")
    response_html.encode('utf-8')

    #Convert html to json
    response_json = response.json()
    print(response_json)
    
    #Create new excel file for first sheet
    if i == 1:
 
        writer = pd.ExcelWriter(os.path.join("DATARAW", 'company_sector_data_uncleaned.xlsx'), engine = 'openpyxl')
 
        df1 = pd.DataFrame(response_json) 
        df1['sector'] = sector_name
        df1['sub sector'] = sub_sector_name
        df1.to_excel(writer \
        , sheet_name = sheet_name \
        , index = False)
        writer.save()
        writer.close()

    #Append to the newly created excel file
    elif i != 1: 

        book = load_workbook(os.path.join("DATARAW", 'company_sector_data_uncleaned.xlsx'))
        writer = pd.ExcelWriter(os.path.join("DATARAW", 'company_sector_data_uncleaned.xlsx'), engine = 'openpyxl')
        writer.book = book

        df1 = pd.DataFrame(response_json) 
        df1['sector'] = sector_name
        df1['sub sector'] = sub_sector_name
        df1.to_excel(writer \
            , sheet_name = sheet_name \
            , index = False)
        writer.save()
        writer.close()

    else:
        print("Something is wrong")

    i += 1