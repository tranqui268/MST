package org.example.mapper;

import org.apache.ibatis.annotations.Param;
import org.example.model.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerMapper {
    List<Customer> getFilteredCustomer(Map<String, Object> filter);
    int countFilteredCustomer(Map<String, Object> filter);
    Customer getCustomerByEmail(@Param("customer_id") int customer_id, @Param("email") String email);

    int addCustomer(@Param("name") String name, @Param("email") String email, @Param("tel_num") String tel_num, @Param("address")String address);
    int updateCustomer(@Param("customer_id") int customer_id ,@Param("name") String name, @Param("email") String email, @Param("tel_num") String tel_num, @Param("address")String address);
}
