SELECT *
FROM genius_data_202002
where Department = 'SF1' & 'SF3'
and Year = '2020'
and Month = '2'
and LargeCat = 'Mouse'
and MediumCat = 'Wireless Mouse' or 'Gaming KB'
and Description = 'OBM';

/*, 'Sls CD1 Desc#', 'Customer Number', 'Order Number', 'Foreign Extended Price', 'Quantity Shipped'
'Computer Peripheral'
'Mouse F.G.I.'  '19100542', 'SF2', '', 'Peru', '100314', 'EXPORT. IMPORT. 
IGARASHI ASCEN', '100314', 'Igarashi', 'Mouse', 'Wireless Mouse', 'Computer Peripheral', 
'Mouse F.G.I.', 'Wireless Mouse', 'NX-7000', 'Optical & Wirless Mouse', 
'RS2,NX-7000,BLUE,G5,HANGER', '31030109109', '自製', '2020', '2', '30.25', 
'4.1', '3280', '2307.52', '972.48', '800', 'OBM'

*/