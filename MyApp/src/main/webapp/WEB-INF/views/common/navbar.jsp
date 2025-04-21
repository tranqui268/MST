  <%@ taglib prefix="s" uri="/struts-tags" %>


  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
      <div class="collapse navbar-collapse justify-content-start">
        <ul class="navbar-nav">
          <li class="nav-item">
            <a class="nav-link text-primary" href="product.action" data-page="product">Products</a>
          </li>         
          <li class="nav-item">
            <a class="nav-link text-primary" href="customer.action" data-page="customer">Customers</a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-primary" href="user.action" data-page="user">Users</a>
          </li>
        </ul>
      </div>
  
      <div class="d-flex align-items-center">
        <s:if test="session.loggedUser != null">
          <span class="navbar-text mr-3">&#128100; <s:property value="#session.loggedUser.group_role"/></span>
        </s:if>
        <a href="logout.action" class="btn btn-danger">Logout</a>
      </div>
    </div>
  </nav>
  

  <script>
    document.addEventListener("DOMContentLoaded", function () {
      const currentPage = window.location.pathname.split("/").pop().split(".")[0]; // ví dụ: user từ "user.action"
  
      
      document.querySelectorAll('.nav-link').forEach(function (link) {
        if (link.dataset.page === currentPage) {
          link.classList.add('bg-danger', 'text-white', 'active');
        } else {
          link.classList.remove('bg-danger', 'text-white', 'active');
        }
      });
    });
  </script>
  



