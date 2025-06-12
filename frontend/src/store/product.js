import { create } from "zustand";

// Get the API URL from environment variables
const API_URL = import.meta.env.VITE_API_URL || "";

export const useProductStore = create((set) => ({
  products: [],
  setProducts: (products) => set({ products }),
  createProduct: async (newProduct) => {
    if (!newProduct.name || !newProduct.image || !newProduct.price) {
      return { success: false, message: "Please fill in all fields." };
    }

    console.log("Making API request to:", `${API_URL}/api/products`);

    try {
      const res = await fetch(`${API_URL}/api/products`, {
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
      console.log("Fetching products from:", `${API_URL}/api/products`);
      const res = await fetch(`${API_URL}/api/products`);

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
    const res = await fetch(`${API_URL}/api/products/${pid}`, {
      method: "DELETE",
    });
    const data = await res.json();
    if (!data.success) return { success: false, message: data.message };

    // update the ui immediately, without needing a refresh
    set((state) => ({
      products: state.products.filter((product) => product._id !== pid),
    }));
    return { success: true, message: data.message };
  },
  updateProduct: async (pid, updatedProduct) => {
    const res = await fetch(`${API_URL}/api/products/${pid}`, {
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
  },
}));
