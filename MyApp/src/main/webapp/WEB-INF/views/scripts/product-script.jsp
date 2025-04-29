           <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
           <%@ taglib prefix="s" uri="/struts-tags" %>
           <%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
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
                                        if (response.data && response.data.length > 0) {
                                            console.log('Response:', response);
                                            const startIndex = (page - 1) * response.paginationInfo.pageSize;
                                            $.each(response.data, function (index, product) {
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

                                            $('#total').html('<p>Hiển thị từ ' + (startIndex + 1) + ' ~ ' + (startIndex + response.data.length) + ' trong tổng số ' + response.paginationInfo.totalProducts + ' sản phẩm</p>');
                                            $('[data-toggle="tooltip"]').tooltip();

                                        } else {
                                            tableBody.append('<tr><td colspan="5" class="text-center">Không có dữ liệu</td></tr>');
                                        }

                                        // Hiển thị phân trang
                                        let pagination = $('#pagination');
                                        pagination.empty();
                                        let paginationInfo = response.paginationInfo ?? 0;
                                        let currentPage = paginationInfo.currentPage ?? 0;
                                        let totalPages = paginationInfo.totalPages ?? 0;

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
                                loadProduct(1);


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
                                            data: { productId: productId },
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