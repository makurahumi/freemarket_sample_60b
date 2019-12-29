# README

## Usersテーブル
|Column|Type|Options|
|------|----|-------|
|nickname|string|unique: false|
|mail|string|unique: false|
|password|string|unique: false|
|lastname|string|null: false|
|firstname|string|null: false|
|lastname_kana|string|null: false|
|firstname_kana|string|null: false|
|birth_year|integer|null: false|
|birth_month|integer|null: false|
|birth_day|integer|null: false|
|phone_num|string|null: false|
|authentication_code|string|null: false|
### Association
- has_many :products, through: :products_users
- has_one :users, dependent: :destroy
- has_one :address, dependent: :destroy
- has_many :reference, dependent: :destroy

## Adressesテーブル
|Column|Type|Options|
|------|----|-------|
|plofiletext|string|null: false|
|zip_code|string|null: false|
|prefectures|string|null: false|
|city|string|null: false|
|block|string|null: false|
|building_name|string|
### Association
- belongs_to :users

## Productsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|description|string|null: false|
|size|string|
|condition|string|null: false|
|delivery_charge|string|null: false|
|delivery_way|string|null: false|
|delivery_area|string|null: false|
|delivery_days|string|null: false|
|price|integer|null: false|
|user_id|references|null: false, foreign_key: true|
|category_id|references|null: false, foreign_key: true|
### Association
- belongs_to :user
- belongs_to :product
- has_many :users, through: :products_users
- has_many :buying_coment_id, :refrence, :null: false
- has_many :product_image_id, :refrence, :null: false
- has_many favorite_id, :refrence, :null: false

## Products_Usersテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|references|null: false, foreign_key: true|
|product_id|references|null: false, foreign_key: true|
### Association
- belongs_to :user
- belongs_to :product


## Categoryテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
### Association
- belongs_to :product
- has_many :brands, through: :category_brands

## Brandsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
### Association
- belongs_to :product
- has_many :category, through: :category_brands

## Category_Brandsテーブル
|Column|Type|Options|
|------|----|-------|
|catergory_id|references|null: false, foreign_key: true|
|brand_id|references|null: false, foreign_key: true|
### Association
- belongs_to :product

## Product_image
|Column|Type|Options|
|------|----|-------|
|product_id|references|null: false, foreign_key: true|
|image|string|
### Association
- belongs_to :product


## Paymentテーブル
|Column|Type|Options|
|------|----|-------|
|card_num|integer|null: false, foreign_key: true|
|use_year|integer|null: false, foreign_key: true|
|use_month|integer|null: false, foreign_key: true|
|security_code|integer|null: false, foreign_key: true|
|user_id|references|null: false, foreign_key: true|
### Association
- has_many :product



## Adressテーブル
|Column|Type|Options|
|------|----|-------|
|plofiletext|string|null: false|
|zip_code|string|null: false|
|prefectures|string|null: false|
|city|string|null: false|
|block|string|null: false|
|building_name|string|
### Association
- belongs_to :users
