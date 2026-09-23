import { useEffect, useState } from "react";

import Header from "../components/Header";
import Sidebar from "../components/Sidebar";
import Navbar from "../components/Navbar";
import ProductCard from "../components/ProductCard";
import LoadingSpinner from "../components/LoadingSpinner";
import ErrorMessage from "../components/ErrorMessage";

import { getProducts } from "../services/productService";

function Products() {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    async function loadProducts() {
      try {
        const data = await getProducts();
        setProducts(data);
      } catch {
        setError("Unable to load applications.");
      } finally {
        setLoading(false);
      }
    }

    loadProducts();
  }, []);

  return (
    <div className="app-layout">
      <Sidebar />

      <div className="main-area">
        <Navbar />
        <Header />

        <main className="page-content">
          <h2>Applications</h2>

          <p>
            Applications and services managed by the
            DevSecOps platform.
          </p>

          {loading && <LoadingSpinner />}

          {error && <ErrorMessage message={error} />}

          {!loading && !error && (
            <div className="products-grid">
              {products.map((product) => (
                <ProductCard
                  key={product.id}
                  product={product}
                />
              ))}
            </div>
          )}
        </main>
      </div>
    </div>
  );
}

export default Products;