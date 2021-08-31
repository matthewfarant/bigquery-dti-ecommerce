SELECT 
        cat.*,
        plist.v2ProductName as product_name,
        COALESCE(sal.total_ordered,0) as total_ordered,
        prod.stockLevel,
        CASE
            WHEN prod.stockLevel = 0 THEN NULL
            ELSE ROUND(COALESCE(sal.total_ordered,0)/prod.stockLevel,4)
        END as stockRatio,
        CASE
            WHEN prod.stockLevel = 0 OR ROUND(COALESCE(sal.total_ordered,0)/prod.stockLevel,4) >= 1 THEN 'Out of Stock'
            ELSE 'Sufficient'
        END as stockStatus,
        prod.restockingLeadTime,
        prod.sentimentScore
    FROM `data-to-insights.ecommerce.categories` cat
    LEFT JOIN `data-to-insights.ecommerce.product_list` plist       ON cat.productSKU = plist.productSKU
    LEFT JOIN `data-to-insights.ecommerce.products` prod            ON cat.productSKU = prod.SKU
    LEFT JOIN `data-to-insights.ecommerce.sales_by_sku` sal         ON cat.productSKU = sal.productSKU
