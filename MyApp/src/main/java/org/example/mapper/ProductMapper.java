package org.example.mapper;

import org.apache.ibatis.annotations.Param;
import org.example.model.Product;

import java.util.List;
import java.util.Map;

public interface ProductMapper {
    int countFilteredProducts(Map<String, Object> filter);
    List<Product> getFilteredProducts(Map<String, Object> filter);

    int deleteProduct(@Param("product_id") String id);

    int addProduct(
            @Param("product_id") String id,
            @Param("product_name") String name,
            @Param("product_image") String url,
            @Param("product_price") Double price,
            @Param("is_sales") int status,
            @Param("description") String description
    );

    String getLastProductIdByPrefix(String prefix);
}
