from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path("polls/", include("polls_app.urls")),
    path("admin/", admin.site.urls),
]