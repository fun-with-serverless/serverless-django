from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path("polls_app/", include("polls_app.urls")),
    path("admin/", admin.site.urls),
]