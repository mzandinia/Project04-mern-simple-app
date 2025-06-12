import { create } from "zustand";

// Define API_URL without the domain - we'll use relative paths
const API_URL = ""; // Empty string for relative paths

export const useProductStore = create((set) => ({
  products: [],
  setProducts: (products) => set({ products }),
  createProduct: async (newProduct) => {
    if (!newProduct.name || !newProduct.image || !newProduct.price) {
      return { success: false, message: "Please fill in all fields." };
    }

    console.log("Making API request to:", `/api/products`);

    try {
      const res = await fetch(`/api/products`, {
        // Use relative path
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(newProduct),
      });

      if (!res.ok) {
        const errorText = await res.text();
        console.error("API Error:", errorText);
        return { success: false, message: `Server error: ${res.status}` };
      }

      const data = await res.json();
      set((state) => ({ products: [...state.products, data.data] }));
      return { success: true, message: "Product created successfully" };
    } catch (error) {
      console.error("API Request failed:", error);
      return { success: false, message: error.message };
    }
  },
  fetchProducts: async () => {
    try {
      console.log("Fetching products from:", `/api/products`);
      const res = await fetch(`/api/products`); // Use relative path

      if (!res.ok) {
        const errorText = await res.text();
        console.error("API Error:", errorText);
        return;
      }

      const data = await res.json();
      set({ products: data.data });
    } catch (error) {
      console.error("Failed to fetch products:", error);
    }
  },
  deleteProduct: async (pid) => {
    try {
      const res = await fetch(`/api/products/${pid}`, {
        // Use relative path
        method: "DELETE",
      });
      const data = await res.json();
      if (!data.success) return { success: false, message: data.message };

      // update the ui immediately, without needing a refresh
      set((state) => ({
        products: state.products.filter((product) => product._id !== pid),
      }));
      return { success: true, message: data.message };
    } catch (error) {
      console.error("Delete product failed:", error);
      return { success: false, message: error.message };
    }
  },
  updateProduct: async (pid, updatedProduct) => {
    try {
      const res = await fetch(`/api/products/${pid}`, {
        // Use relative path
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(updatedProduct),
      });
      const data = await res.json();
      if (!data.success) return { success: false, message: data.message };

      // update the ui immediately, without needing a refresh
      set((state) => ({
        products: state.products.map((product) =>
          product._id === pid ? data.data : product
        ),
      }));

      return { success: true, message: data.message };
    } catch (error) {
      console.error("Update product failed:", error);
      return { success: false, message: error.message };
    }
  },
}));
