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
import org.example.util.Validate;

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
    private String priceFrom;
    private String priceTo;

    // add product
    private File file;
    private String fileContentType;
    private String fileFileName;
    private String price;
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
        cloudinaryService = new CloudinaryService();
    }




    public String getListProductFilter(){
        paginationResponse = new PaginationResponse<>();
        System.out.println("DATARESULT" + name + status + priceFrom + priceTo);
        boolean check = true;

        String nameError = Validate.validateInput(name);
        if (nameError != null){
            paginationResponse.setMessage(nameError);
            check = false;
        }

        String statusError = Validate.validateInput(status);
        if (statusError != null){
            paginationResponse.setMessage(statusError);
            check = false;
        }

        String statusErrorValue = Validate.validateStatus(status);
        if (statusErrorValue != null){
            paginationResponse.setMessage(statusErrorValue);
            check = false;
        }

        String priceFromError = Validate.validateNumber(priceFrom, "Price from");
        if (priceFromError != null){
            paginationResponse.setMessage(priceFromError);
            check = false;
        }

        String priceToError = Validate.validateNumber(priceTo, "Price to");
        if (priceToError != null){
            paginationResponse.setMessage(priceToError);
            check = false;
        }

        Double priceFromDouble = null;
        Double priceToDouble = null;
        try {
            if (priceFrom != null && !priceFrom.trim().isEmpty()){
                priceFromDouble = Double.parseDouble(priceFrom);
            }
            if (priceTo != null && !priceTo.trim().isEmpty()){
                priceToDouble = Double.parseDouble(priceTo);
            }
        }catch (NumberFormatException e){
            check = false;
            paginationResponse.setMessage("Lỗi chuyển đổi giá trị giá.");
        }

        String priceFromDoubleError = Validate.validatePrice(priceFromDouble, "Price from");
        if (priceFromDoubleError != null){
            paginationResponse.setMessage(priceFromDoubleError);
            check = false;
        }

        String priceToDoubleError = Validate.validatePrice(priceToDouble, "Price to");
        if (priceToDoubleError != null){
            paginationResponse.setMessage(priceToDoubleError);
            check = false;
        }

        String priceRangeError = Validate.validatePriceRange(priceFromDouble, priceToDouble);
        if (priceRangeError != null){
            paginationResponse.setMessage(priceRangeError);
            check = false;
        }



        if (!check){
            paginationResponse.setSuccess(false);
            paginationResponse.setData(null);
            paginationResponse.setPaginationInfo(null);
            return SUCCESS;
        }

        products = productService.getProductsWithPagination(name,status,priceFromDouble,priceToDouble,page,pageSize);
        System.out.println("Users after filter: " + products);

        totalProduct = productService.countProducts(name,status,priceFromDouble,priceToDouble);
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
        boolean check = true;
        String nameError = Validate.validateInput(name);
        if (nameError != null){
            messageResponse.setMessage(nameError);
            check = false;
        }

        String statusError = Validate.validateInput(status);
        if (statusError != null){
            messageResponse.setMessage(statusError);
            check = false;
        }

        String priceError = Validate.validateNumber(price, "Price");
        if (priceError != null){
            messageResponse.setMessage(priceError);
            check = false;
        }



        Double priceDouble= null;
        try {
            if (price != null && !price.trim().isEmpty()){
                priceDouble = Double.parseDouble(price);
            }
        }catch (NumberFormatException e){
            check = false;
            messageResponse.setMessage("Lỗi chuyển đổi giá trị giá.");
        }

        String priceDoubleError = Validate.validatePrice(priceDouble, "Price");
        if (priceDoubleError != null){
            messageResponse.setMessage(priceDoubleError);
            check = false;
        }




        if (!check){
            messageResponse.setSuccess(false);
            return SUCCESS;
        }


        System.out.println("SEND-FILE" + file);
        String url = cloudinaryService.uploadImage(file);
        System.out.println("ACTION---Url : "+ url +" name: " + name + "Price: " + price +"Status: " + status+" Description: " + description);
        int rowInsert = productService.addProduct(name, url, priceDouble, Integer.parseInt(status),description);
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
        boolean check = true;
        String nameError = Validate.validateInput(name);
        if (nameError != null){
            messageResponse.setMessage(nameError);
            check = false;
        }

        String statusError = Validate.validateInput(status);
        if (statusError != null){
            messageResponse.setMessage(statusError);
            check = false;
        }

        String priceError = Validate.validateNumber(price, "Price");
        if (priceError != null){
            messageResponse.setMessage(priceError);
            check = false;
        }



        Double priceDouble= null;
        try {
            if (price != null && !price.trim().isEmpty()){
                priceDouble = Double.parseDouble(price);
            }
        }catch (NumberFormatException e){
            check = false;
            messageResponse.setMessage("Lỗi chuyển đổi giá trị giá.");
        }

        String priceDoubleError = Validate.validatePrice(priceDouble, "Price");
        if (priceDoubleError != null){
            messageResponse.setMessage(priceDoubleError);
            check = false;
        }




        if (!check){
            messageResponse.setSuccess(false);
            return SUCCESS;
        }


        System.out.println("SEND-FILE" + file);
        String url = "";
        if (file != null){
            url = cloudinaryService.uploadImage(file);
        } else if (imageUrl != null && !imageUrl.isEmpty()) {
            url = imageUrl;
        }
        System.out.println("ACTION---Url : "+ url +" name: " + name + "Price: " + price +"Status: " + status+" Description: " + description);
        int rowInsert = productService.updateProduct(productId,name, url, priceDouble, Integer.parseInt(status),description);
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

    public String getPriceFrom() {
        return priceFrom;
    }

    public void setPriceFrom(String priceFrom) {
        this.priceFrom = priceFrom;
    }

    public String getPriceTo() {
        return priceTo;
    }

    public void setPriceTo(String priceTo) {
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

    public String getFileFileName() {
        return fileFileName;
    }

    public void setFileFileName(String fileFileName) {
        this.fileFileName = fileFileName;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
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
