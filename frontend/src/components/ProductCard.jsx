import { Package } from "lucide-react";

function ProductCard({ product }) {
  return (
    <div className="product-card">
      <div className="product-icon">
        <Package size={24} />
      </div>

      <div className="product-content">
        <h3>{product.name}</h3>

        <p>
          Description:{" "}
          <strong>{product.description || "No description"}</strong>
        </p>

        <p>
          Price:{" "}
          <strong>₹{Number(product.price).toLocaleString("en-IN")}</strong>
        </p>

        <p>
          Stock:{" "}
          <strong>{product.stock}</strong>
        </p>
      </div>
    </div>
  );
}

export default ProductCard;
