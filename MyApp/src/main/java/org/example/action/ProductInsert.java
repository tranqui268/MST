package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.json.annotations.JSON;
import org.example.model.Product;
import org.example.service.CloudinaryService;
import org.example.service.ProductService;

import java.io.File;

public class ProductInsert extends ActionSupport {
    private File file;
    private String fileContentType;
    private String productId;
    private Product product;
    private String fileName;
    private String name;
    private Double price;
    private String description;
    private String imageUrl;
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

    public String getProductById(){
        product = productService.getProductById(productId);
        if (product != null) success = true;
        else  success = false;
        return SUCCESS;

    }

    public String updateProduct() throws Exception {
        String url = "";
        if (file != null){
            url = cloudinaryService.uploadImage(file);
        } else if (imageUrl != null && !imageUrl.isEmpty()) {
            url = imageUrl;
        }
        System.out.println("ACTION---Url : "+ url +" name: " + name + "Price: " + price +"Status: " + status+" Description: " + description);
        int rowInsert = productService.updateProduct(productId,name, url, price,status,description);
        if (rowInsert > 0) success = true;
        else success = false;

        return SUCCESS;
    }

    @JSON(serialize = false)
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

    public String getFileContentType() {
        return fileContentType;
    }

    public void setFileContentType(String fileContentType) {
        this.fileContentType = fileContentType;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
