package org.example.service;

import cz.jirutka.unidecode.Unidecode;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.example.mapper.ProductMapper;
import org.example.model.Product;

import java.io.InputStream;
import java.text.Normalizer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductService {
    private SqlSessionFactory sqlSessionFactory;
    public ProductService() throws Exception{
        String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
    }

    public List<Product> getProductsWithPagination(String name, String status, Double priceFrom, Double priceTo, int page, int pageSize) {
        try(SqlSession session = sqlSessionFactory.openSession()){
            ProductMapper mapper = session.getMapper(ProductMapper.class);
            Map<String, Object> params = new HashMap<>();
            params.put("name", name);
            params.put("status", status);
            params.put("priceFrom", priceFrom);
            params.put("priceTo", priceTo);
            params.put("offset", (page - 1) * pageSize);
            params.put("pageSize", pageSize);
            System.out.println("FETCHDATA:" +mapper.getFilteredProducts(params));
            return mapper.getFilteredProducts(params);
        }
    }

    public int countProducts(String name, String status, Double priceFrom, Double priceTo ) {
        try(SqlSession session = sqlSessionFactory.openSession()){
            ProductMapper mapper = session.getMapper(ProductMapper.class);
            Map<String, Object> params = new HashMap<>();
            params.put("name", name);
            params.put("status", status);
            params.put("priceFrom", priceFrom);
            params.put("priceTo", priceTo);
            return mapper.countFilteredProducts(params);
        }

    }

    public int deletProduct(String id){
        try(SqlSession session = sqlSessionFactory.openSession(true)){
            ProductMapper mapper = session.getMapper(ProductMapper.class);
            return mapper.deleteProduct(id);
        }
        catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    public int addProduct(String name, String url, Double price, int status, String description){
        String id = generateProductId(name);
        System.out.println("SERVICE---ID: " + id +" Url : "+ url +" name: " + name + "Price: " + price +"Status: " + status+" Description: " + description);
        try(SqlSession session = sqlSessionFactory.openSession(true)){
            ProductMapper mapper = session.getMapper(ProductMapper.class);
            return mapper.addProduct(id, name, url, price, status, description);
        }
        catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    public Product getProductById(String id){
        try(SqlSession session = sqlSessionFactory.openSession()){
            ProductMapper mapper = session.getMapper(ProductMapper.class);
            return mapper.getProductById(id);
        }
    }

    public int updateProduct(String id,String name, String url, Double price, int status, String description){
        try(SqlSession session = sqlSessionFactory.openSession(true)){
            ProductMapper mapper = session.getMapper(ProductMapper.class);
            return mapper.updateProduct(id, name, url, price, status, description);
        }
        catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    private String generateProductId(String productName) {
        try(SqlSession session = sqlSessionFactory.openSession()){
            ProductMapper mapper = session.getMapper(ProductMapper.class);
            if (productName == null || productName.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên sản phẩm không được để trống.");
            }

            Unidecode unidecode = Unidecode.toAscii();


            String firstChar = productName.trim().substring(0, 1).toUpperCase();


            // Lấy số thứ tự lớn nhất hiện tại cho chữ cái đầu này
            String prefix = unidecode.decode(firstChar);
            String lastProductId = mapper.getLastProductIdByPrefix(prefix);
            int sequenceNumber = 1;

            if (lastProductId != null) {
                // Lấy số thứ tự từ product_id cuối cùng (ví dụ: "S000000001" -> 1)
                String sequencePart = lastProductId.substring(1);
                sequenceNumber = Integer.parseInt(sequencePart) + 1;
            }

            // Format số thứ tự thành 9 chữ số (ví dụ: 1 -> "000000001")
            String sequenceFormatted = String.format("%09d", sequenceNumber);
            return prefix + sequenceFormatted;
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }
}


