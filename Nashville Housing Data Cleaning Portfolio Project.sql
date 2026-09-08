Select *
From NashvilleHousing

-- Change the Date Format
Select CAST(SaleDate as date) as SaleDate
From NashvilleHousing
Order by SaleDate asc

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

Select SaleDateConverted
From NashvilleHousing

------------------------------------------Filling Up Null PropertyAddress---------------------------------------------------
--PropertyAddress with Nulls
Select *
From NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

--
Select 
	a.ParcelID, 
	a.PropertyAddress, 
	b.ParcelID, 
	b.PropertyAddress, 
	ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing as a
Join NashvilleHousing as b
	On a.[UniqueID ] != b.[UniqueID ]
	And a.ParcelID = b.ParcelID
Where a.PropertyAddress is null

--
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing as a
Join NashvilleHousing as b
	On a.[UniqueID ] != b.[UniqueID ]
	And a.ParcelID = b.ParcelID
Where a.PropertyAddress is null


----------------------Splitting Address into Individual Columns (Address, City, State)----------------------------- 
-- 
Select 
	TRIM(SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)) as Address,
	TRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))) as City
From NashvilleHousing

--Creating Address & City Columns for Splitted PropertyAddress 

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = TRIM(SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1))

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = TRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)))


---Splitting OwnerAddress Using PARSENAME
Select OwnerAddress
From NashvilleHousing

Select 
TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)) AS OwnerSplitAddress,
TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)) AS OwnerSplitCity,
TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)) AS OwnerSplitState
From NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'),3))

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'),2))

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState = TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'),1))

--Changing Column SoldAsVacant From Y and N to Yes and No
Select distinct(SoldAsVacant)
from NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = 'Yes'
Where SoldAsVacant = 'Y'

Update NashvilleHousing
Set SoldAsVacant = 'No'
Where SoldAsVacant = 'N'

--Removing Duplicates Using CTE
With RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order By UniqueID
				)
				row_num	

From NashvilleHousing
)

Select *
FROM RowNumCTE
where row_num = 2


--Create New Table Instead of Deleting
--Where PropertyAddress and OwnerAddress is Splitted and SoldAsVacant is Yes and No Only
Create Table SplittedNashvilleHousing
(
UniqueID float,
ParcellID nvarchar(255),
LandUse nvarchar(255),
PropertyAddress nvarchar(255),
PropertyCity nvarchar(255),
SaleDate date,
SalePrice bigint,
LegalReference nvarchar(255),
SoldAsVacant nvarchar(255),
OwnerName nvarchar(255),
OwnerAddress nvarchar(255),
OwnerCity nvarchar(255),
OwnerState nvarchar(255),
Acreage float,
TaxDistrict nvarchar(255),
LandValue bigint,
BuildingValue bigint,
TotalValue bigint,
YearBuilt bigint,
Bedrooms bigint,
Fullbath bigint,
HalfBath bigint,
SaleDateConverted date
)

Insert Into SplittedNashvilleHousing
Select
	[UniqueID ],
	ParcelID,
	LandUse,
	PropertyAddress = TRIM(PARSENAME(REPLACE(PropertyAddress, ',', '.'),2)),
	PropertyCity = TRIM(PARSENAME(REPLACE(PropertyAddress, ',', '.'),1)),
	SaleDateConverted,
	SalePrice,
	LegalReference,
	Case
		When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
	End,
	OwnerName,
	OwnerSplitAddress = TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)),
	OwnerSplitCity = TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)),
	OwnerSplitState = TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)),
	Acreage,
	TaxDistrict,
	LandValue,
	BuildingValue,
	TotalValue,
	YearBuilt,
	Bedrooms,
	Fullbath,
	HalfBath,
	SaleDateConverted
From NashvilleHousing

Select *
From SplittedNashvilleHousing