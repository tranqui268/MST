package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.example.service.CloudinaryService;
import org.example.service.ProductService;

import java.io.File;

public class ProductInsert extends ActionSupport {
    private File file;
    private String name;
    private Double price;
    private String description;
    private int status;
    private boolean success;
    private ProductService productService;
    private CloudinaryService cloudinaryService;

    public ProductInsert() throws Exception {
        cloudinaryService = new CloudinaryService();
        productService = new ProductService();
    }


    public String addProduct() throws Exception {
        String url = cloudinaryService.uploadImage(file);
        System.out.println("ACTION---Url : "+ url +" name: " + name + "Price: " + price +"Status: " + status+" Description: " + description);
        int rowInsert = productService.addProduct(name, url, price,status,description);
        if (rowInsert > 0) success = true;
        else success = false;
        return SUCCESS;
    }

    public File getFile() {
        return file;
    }

    public void setFile(File file) {
        this.file = file;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }
}
