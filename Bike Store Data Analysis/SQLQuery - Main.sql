SELECT 
    ord.order_id,
    CONCAT(cst.first_name, ' ', cst.last_name) AS Customer_Name,
    cst.city,
    cst.state,
    ord.order_date,
    pdc.product_name,
    pdcat.category_name,
    strs.store_name,
    CONCAT(stf.first_name, ' ', stf.last_name) AS Sales_Rep_Name,
    SUM(ordi.quantity) AS Total_Units,
    SUM(ordi.quantity * ordi.list_price) AS revenue
FROM 
    sales.orders ord
JOIN 
    sales.customers cst ON ord.customer_id = cst.customer_id
JOIN 
    sales.order_items ordi ON ord.order_id = ordi.order_id
JOIN 
    production.products pdc ON ordi.product_id = pdc.product_id
JOIN 
    production.categories pdcat ON pdc.category_id = pdcat.category_id
JOIN 
    sales.stores strs ON ord.store_id = strs.store_id
JOIN 
    sales.staffs stf ON ord.staff_id = stf.staff_id
GROUP BY 
    ord.order_id,
    CONCAT(cst.first_name, ' ', cst.last_name),
    cst.city,
    cst.state,
    ord.order_date,
    pdc.product_name,
    pdcat.category_name,
    strs.store_name,
    CONCAT(stf.first_name, ' ', stf.last_name);
