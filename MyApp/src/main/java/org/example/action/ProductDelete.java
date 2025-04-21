package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.example.service.ProductService;

public class ProductDelete extends ActionSupport {
    private String product_id;
    private boolean success;

    private ProductService productService;

    public  ProductDelete() throws Exception {
        productService = new ProductService();
    }

    public String deleteProduct(){
        int rowUpdate = productService.deletProduct(product_id);
        if (rowUpdate > 0) success = true;
        else  success = false;
        return SUCCESS;
    }

    public String getProduct_id() {
        return product_id;
    }

    public void setProduct_id(String product_id) {
        this.product_id = product_id;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }
}
