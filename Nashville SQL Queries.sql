/*

Cleaning Data in SQL using Queries.

Dataset: Nashville Housing Data
Dataset Range: 1/2/2013 - 12/13/2019

*/

SELECT *
FROM [DA-PortfolioProject1].dbo.NashvilleHousing

-------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SaleDate, CONVERT(DATE, SaleDate)
FROM [DA-PortfolioProject1].dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate) 

SELECT SaleDateConverted
FROM NashvilleHousing

-------------------------------------------------------------------------------------------------------------

-- Populate Address Data

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT ParcelID, PropertyAddress
FROM NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT nh_1.ParcelID, nh_1.PropertyAddress, nh_2.ParcelID, nh_2.PropertyAddress, 
ISNULL(nh_1.PropertyAddress, nh_2.PropertyAddress)
FROM NashvilleHousing nh_1
JOIN NashvilleHousing nh_2
	ON nh_1.ParcelID = nh_2.ParcelID
	AND nh_1.[UniqueID ] <> nh_2.[UniqueID ]
WHERE nh_1.PropertyAddress IS NULL

UPDATE nh_1
SET PropertyAddress = ISNULL(nh_1.PropertyAddress, nh_2.PropertyAddress)
FROM NashvilleHousing nh_1
JOIN NashvilleHousing nh_2
	ON nh_1.ParcelID = nh_2.ParcelID
	AND nh_1.[UniqueID ] <> nh_2.[UniqueID ]
WHERE nh_1.PropertyAddress IS NULL

-------------------------------------------------------------------------------------------------------------

-- Splitting Address Into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) 

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) 

SELECT PropertyAddress, PropertySplitAddress, PropertySplitCity 
FROM NashvilleHousing

SELECT OwnerAddress
FROM NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress,',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2) 

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)

SELECT OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
FROM NashvilleHousing

-------------------------------------------------------------------------------------------------------------

-- Change "Y" & "N" To "Yes" & "No" in "SoldAsVacant" Column

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing

-- Remove Unused Columns

SELECT * 
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate, OwnerAddress, PropertyAddress


 
