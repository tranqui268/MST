package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.example.dto.AddProductResponse;
import org.example.dto.BaseResponse;
import org.example.dto.MessageResponse;
import org.example.dto.PaginationResponse;
import org.example.model.Product;
import org.example.model.User;
import org.example.service.CloudinaryService;
import org.example.service.ProductService;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductAction  extends ActionSupport {
    private int page =1;
    private int pageSize = 20;
    private int totalProduct;
    private int totalPages;
    private List<Product> products;
    private Map<String, Object> paginationInfo;
    private boolean success;

    // Filter
    private String name;
    private String status;
    private Double priceFrom;
    private Double priceTo;

    // add product
    private File file;
    private String fileContentType;
    private String fileName;
    private Double price;
    private String description;

    // getProductById
    private String productId;

    // update Product
    private String imageUrl;


    // Response
    private PaginationResponse<List<Product>> paginationResponse;
    private MessageResponse messageResponse;
    private BaseResponse<Product> productBaseResponse;

    private ProductService productService;
    private CloudinaryService cloudinaryService;

    public ProductAction() throws Exception {
        productService = new ProductService();
    }




    public String getListProductFilter(){
        paginationResponse = new PaginationResponse<>();
        System.out.println("DATARESULT" + name + status + priceFrom + priceTo);
        products = productService.getProductsWithPagination(name,status,priceFrom,priceTo,page,pageSize);
        System.out.println("Users after filter: " + products);

        totalProduct = productService.countProducts(name,status,priceFrom,priceTo);
        totalPages = (int) Math.ceil((double) totalProduct / pageSize);
        paginationInfo = new HashMap<>();
        paginationInfo.put("currentPage", page);
        paginationInfo.put("pageSize", pageSize);
        paginationInfo.put("totalProducts", totalProduct);
        paginationInfo.put("totalPages", totalPages);

        if (products != null){
            paginationResponse.setSuccess(true);
            paginationResponse.setMessage("Lấy dữ liệu thành công");
            paginationResponse.setData(products);
            paginationResponse.setPaginationInfo(paginationInfo);
        }else {
            paginationResponse.setSuccess(false);
            paginationResponse.setMessage("Lấy dữ liệu thất bại");
            paginationResponse.setData(null);
            paginationResponse.setPaginationInfo(null);
        }
        return SUCCESS;
    }

    public String addProduct() throws Exception {
       messageResponse = new MessageResponse();

        String url = cloudinaryService.uploadImage(file);
        System.out.println("ACTION---Url : "+ url +" name: " + name + "Price: " + price +"Status: " + status+" Description: " + description);
        int rowInsert = productService.addProduct(name, url, price, Integer.parseInt(status),description);
        if (rowInsert > 0){
            messageResponse.setSuccess(true);
            messageResponse.setMessage("Thêm sản phẩm thành công");
        }else {
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Thêm sản phẩm thất bại");
        }
        return SUCCESS;
    }

    public String getProductById(){
        productBaseResponse = new BaseResponse<>();
        Product product = productService.getProductById(productId);
        if (product != null) {
            productBaseResponse.setData(product);
            productBaseResponse.setSuccess(true);
            productBaseResponse.setMessage("Thành công");
        }
        else{
            productBaseResponse.setData(null);
            productBaseResponse.setSuccess(false);
            productBaseResponse.setMessage("thất bại");
        }
        return SUCCESS;

    }

    public String updateProduct() throws Exception {
        messageResponse = new MessageResponse();
        String url = "";
        if (file != null){
            url = cloudinaryService.uploadImage(file);
        } else if (imageUrl != null && !imageUrl.isEmpty()) {
            url = imageUrl;
        }
        System.out.println("ACTION---Url : "+ url +" name: " + name + "Price: " + price +"Status: " + status+" Description: " + description);
        int rowInsert = productService.updateProduct(productId,name, url, price, Integer.parseInt(status),description);
        if (rowInsert > 0){
            messageResponse.setSuccess(true);
            messageResponse.setMessage("Sửa thành công");
        }
        else {
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Sửa thất bại ");
        }

        return SUCCESS;
    }

    public String deleteProduct(){
        messageResponse = new MessageResponse();
        int rowUpdate = productService.deletProduct(productId);
        if (rowUpdate > 0){
            messageResponse.setSuccess(true);
            messageResponse.setMessage("Xóa thành công");
        }
        else{
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Xóa thất bại ");
        }
        return SUCCESS;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getTotalProduct() {
        return totalProduct;
    }

    public void setTotalProduct(int totalProduct) {
        this.totalProduct = totalProduct;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public List<Product> getProducts() {
        return products;
    }

    public void setProducts(List<Product> products) {
        this.products = products;
    }

    public Map<String, Object> getPaginationInfo() {
        return paginationInfo;
    }

    public void setPaginationInfo(Map<String, Object> paginationInfo) {
        this.paginationInfo = paginationInfo;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Double getPriceFrom() {
        return priceFrom;
    }

    public void setPriceFrom(Double priceFrom) {
        this.priceFrom = priceFrom;
    }

    public Double getPriceTo() {
        return priceTo;
    }

    public void setPriceTo(Double priceTo) {
        this.priceTo = priceTo;
    }

    public File getFile() {
        return file;
    }

    public void setFile(File file) {
        this.file = file;
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

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public PaginationResponse getPaginationResponse() {
        return paginationResponse;
    }

    public void setPaginationResponse(PaginationResponse paginationResponse) {
        this.paginationResponse = paginationResponse;
    }

    public MessageResponse getMessageResponse() {
        return messageResponse;
    }

    public void setMessageResponse(MessageResponse messageResponse) {
        this.messageResponse = messageResponse;
    }

    public BaseResponse<Product> getProductBaseResponse() {
        return productBaseResponse;
    }

    public void setProductBaseResponse(BaseResponse<Product> productBaseResponse) {
        this.productBaseResponse = productBaseResponse;
    }
}
