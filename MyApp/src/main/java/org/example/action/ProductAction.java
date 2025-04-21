package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.example.model.Product;
import org.example.model.User;
import org.example.service.ProductService;

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

    private ProductService productService;

    public ProductAction() throws Exception {
        productService = new ProductService();
    }

    public String getListProductFilter(){
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
}
