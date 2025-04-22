<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="s" uri="/struts-tags" %>
        <%@ page import="org.example.model.User" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Product</title>
                <link rel="stylesheet"
                    href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

            </head>
            <style>
                .product-name {
                    position: relative;
                    cursor: pointer;
                }

                .tooltip-image {
                    position: absolute;
                    z-index: 1000;
                    top: -160px;
                    left: 0;
                    background: white;
                    padding: 5px;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
                }
            </style>

            <body class="bg-light">
                <s:set var="section" value="'product'" scope="request" />
                <div class="container">
                    <h2 class="bg-info text-white text-center">QUẢN LÝ SẢN PHẨM</h2>
                </div>

                <%@ include file="/WEB-INF/views/common/navbar.jsp" %>

                    <div>
                        <form id="searchForm" method="get" class="form-inline mb-2">
                            <input id="searchName" type="text" name="name" placeholder="Nhập tên sản phẩm"
                                class="form-control mr-1" />

                            <select id="searchStatus" name="status" class="form-control mr-1">
                                <option value="">Chọn trạng thái</option>
                                <option value="1">Có hàng bán</option>
                                <option value="0">Dừng bán</option>
                            </select>
                            <input id="priceFrom" type="number" name="priceFrom" placeholder="Giá bán từ" min="0"
                                step="10" class="form-control mr-1" />
                            <input id="priceTo" type="number" name="priceTo" placeholder="Giá bán đến" min="0" step="10"
                                class="form-control mr-1" />


                            <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Tìm kiếm</button>
                            <a href="#" id="clearSearchBtn" class="btn btn-secondary ml-1"><i
                                    class="bi bi-x-circle"></i> Xóa tìm</a>
                        </form>
                        <a id="btnAdd" class="btn btn-secondary ml-1"><i class="bi bi-person-fill-add"
                                style="color: blue"></i>Thêm mới</a>
                        <div class="d-flex align-items-center justify-content-end" id="total">

                        </div>

                    </div>


                    <table id="productTable" class="table table-bordered table-striped text-center">
                        <thead class="thead-light">
                            <tr>
                                <th>#</th>
                                <th>Tên sản phẩm</th>
                                <th>Mô tả</th>
                                <th>Giá</th>
                                <th>Tình trạng</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="productTableBody">

                        </tbody>
                    </table>


                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center" id="pagination">
                        </ul>
                    </nav>


                    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
                    <script
                        src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
                    <script>
                        if (typeof jQuery === 'undefined') {
                            console.error('jQuery is not loaded!');
                        } else {
                            console.log('jQuery loaded successfully:', jQuery.fn.jquery);
                            if (typeof $.ajax === 'undefined') {
                                console.error('$.ajax is not available! Make sure to use the full jQuery version.');
                            } else {
                                console.log('$.ajax is available');
                            }
                        }

                        $(document).ready(function () {

                            console.log('Document ready - Starting AJAX call');

                            loadProduct(1);
                            // fetch data user
                            function loadProduct(page = 1) {
                                let searchParams = {
                                    name: $('#searchName').val() ?? '',
                                    status: $('#searchStatus').val() ?? '',
                                    priceFrom: $('#priceFrom').val() ?? '',
                                    priceTo: $('#priceTo').val() ?? ''
                                };
                                console.log('loadUser function called for page:', page);
                                $.ajax({
                                    url: 'getListProductFilter',
                                    type: 'GET',
                                    data: {
                                        name: searchParams.name,
                                        status: searchParams.status,
                                        priceFrom: searchParams.priceFrom,
                                        priceTo: searchParams.priceTo,
                                        page: page
                                    },
                                    dataType: 'json',
                                    success: function (response) {
                                        console.log('Response:', response);
                                        let tableBody = $('#productTableBody');
                                        tableBody.empty();


                                        // Hiển thị danh sách user
                                        if (response.products && response.products.length > 0) {
                                            console.log('Response:', response);
                                            const startIndex = (page - 1) * response.pageSize;
                                            $.each(response.products, function (index, product) {
                                                let decodedImageUrl = 'https://res.cloudinary.com/dhis8yzem/image/upload/v1741008403/Avatar_default_zfdjrk.png'
                                                if(product.product_image){
                                                    decodedImageUrl = product.product_image.replace(/\\\//g, '/');                                                   
                                                }
                                                let row = '<tr>' +
                                                    '<td>' + (startIndex + index + 1) + '</td>' +
                                                    '<td>' +
                                                    '<span class="product-name" data-image-url="' + decodedImageUrl + '">' +
                                                    product.product_name +
                                                    '</span>' +
                                                    '</td>' +
                                                    '<td>' + product.description + '</td>' +
                                                    '<td>' + '$' + product.product_price + '</td>' +
                                                    '<td>' + (product.is_sales == 1 ? '<span class="text-success">Đang bán</span>' : '<span class="text-danger">Ngừng bán</span>') + '</td>' +
                                                    '<td>' +
                                                    '<a class="editUser text-info mr-2" href="productDetail.action?productId=' + (product.product_id || '' )+ '"><i class="bi bi-pencil-fill" style="color: blue"></i></a>' +
                                                    '<a href="#" class="deleteProduct text-danger mr-2" data-id="' + product.product_id + '"><i class="bi bi-trash-fill" style="color: red;"></i></a>' +

                                                    '</td>' +
                                                    '</tr>';
                                                tableBody.append(row);
                                            });

                                            $('#total').html('<p>Hiển thị từ ' + (startIndex + 1) + ' ~ ' + (startIndex + response.products.length) + ' trong tổng số ' + response.totalProduct + ' sản phẩm</p>');
                                            $('[data-toggle="tooltip"]').tooltip();

                                        } else {
                                            tableBody.append('<tr><td colspan="5" class="text-center">Không có dữ liệu</td></tr>');
                                        }

                                        // Hiển thị phân trang
                                        let pagination = $('#pagination');
                                        pagination.empty();
                                        let paginationInfo = response.paginationInfo;
                                        let currentPage = paginationInfo.currentPage;
                                        let totalPages = paginationInfo.totalPages;

                                        // Nút Previous
                                        if (totalPages > 1) {
                                            if (currentPage > 1) {
                                                pagination.append('<li class="page-item"><a class="page-link" href="#" data-page="' + (currentPage - 1) + '">Previous</a></li>');
                                            } else {
                                                pagination.append('<li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>');
                                            }

                                            // Các số trang
                                            for (let i = 1; i <= totalPages; i++) {
                                                if (i === currentPage) {
                                                    pagination.append('<li class="page-item active"><a class="page-link" href="#">' + i + '</a></li>');
                                                } else {
                                                    pagination.append('<li class="page-item"><a class="page-link" href="#" data-page="' + i + '">' + i + '</a></li>');
                                                }
                                            }

                                            // Nút Next
                                            if (currentPage < totalPages) {
                                                pagination.append('<li class="page-item"><a class="page-link" href="#" data-page="' + (currentPage + 1) + '">Next</a></li>');
                                            } else {
                                                pagination.append('<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>');
                                            }

                                            // Gắn sự kiện cho các nút phân trang
                                            $('.page-link').click(function (e) {
                                                e.preventDefault();
                                                let page = $(this).data('page');
                                                if (page) {
                                                    loadProduct(page);
                                                }
                                            });
                                        }
                                    },
                                    error: function (xhr, status, error) {
                                        console.error('Error fetching users:', error);
                                        console.error('Status:', status);
                                        console.error('XHR:', xhr);
                                        $('#productTableBody').html('<tr><td colspan="5" class="text-center text-danger">Lỗi khi tải dữ liệu</td></tr>');
                                    }
                                });
                            }

                            // event search
                            $('#searchForm').on('submit', function (e) {
                                e.preventDefault();
                                loadProduct(1);
                            });

                            $('#clearSearchBtn').click(function (e) {
                                e.preventDefault();


                                $('#searchName').val('');
                                $('#priceFrom').val('');
                                $('#priceTo').val('');
                                $('#searchStatus').val('');


                                loadProduct(1);
                            });


                            // Delete user
                            $(document).on('click', '.deleteProduct', function () {
                                const $icon = $(this);
                                const productId = $icon.data('id');
                                const name = $icon.closest('tr').find('td').eq(1).text();
                                const is_sales = $icon.closest('tr').find('td').eq(4).text();
                                console.log("is_sales:", is_sales);
                                console.log("typeof is_sales:", typeof is_sales);
                                if (is_sales.trim() === 'Đang bán') {
                                    if (confirm('Bạn có chắc muốn xóa ' + name)) {
                                        $.ajax({
                                            url: 'deleteProduct',
                                            method: 'POST',
                                            data: { product_id: productId },
                                            success: function (response) {
                                                if (response.success) {
                                                    alert("Xóa thành công!");
                                                    loadProduct();
                                                } else {
                                                    alert("Xóa thất bại!");
                                                }
                                            },
                                            error: function () {
                                                alert("Lỗi khi xóa");
                                            }
                                        });
                                    }

                                } else {
                                    alert('Sản phẩm' + name + 'đã ngừng bán')
                                }

                            });

                            // Add these event handlers after your table is created
                            $(document).on('mouseenter', '.product-name', function () {
                                const $this = $(this);
                                let imageUrl = $this.data('image-url');

                                if (!imageUrl || imageUrl.trim() === '') {
                                    imageUrl = 'https://res.cloudinary.com/dhis8yzem/image/upload/v1741008403/Avatar_default_zfdjrk.png';
                                }

                                const tooltip = $('<div class="tooltip-image"><img src="' + imageUrl + '" alt="Product Image" style="max-width: 150px; max-height: 150px;"/></div>');
                                $this.append(tooltip);
                            });

                            $(document).on('mouseleave', '.product-name', function () {
                                $(this).find('.tooltip-image').remove();
                            });


                            $('#btnAdd').on('click', function (e) {
                                e.preventDefault();
                                window.location.href = 'productDetail.action'; // Chuyển hướng đến trang chi tiết sản phẩm
                            });



                        });


                    </script>
            </body>

            </html>