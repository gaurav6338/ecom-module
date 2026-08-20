import React, { useState } from 'react';
import { Plus, Edit, Trash2, Search, X } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export default function AdminProducts() {
  const { products, addProduct, updateProduct, deleteProduct, categories } = useApp();
  const [search, setSearch] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('All');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingProduct, setEditingProduct] = useState(null);

  // Form State
  const [name, setName] = useState('');
  const [category, setCategory] = useState('Electronics');
  const [price, setPrice] = useState('');
  const [discount, setDiscount] = useState('10');
  const [stock, setStock] = useState('20');
  const [description, setDescription] = useState('');
  const [imageUrl, setImageUrl] = useState('');

  const formatCurrency = (amt) => `₹${amt.toLocaleString('en-IN')}`;

  const openAddModal = () => {
    setEditingProduct(null);
    setName('');
    setCategory('Electronics');
    setPrice('');
    setDiscount('10');
    setStock('20');
    setDescription('');
    setImageUrl('https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop&q=80');
    setIsModalOpen(true);
  };

  const openEditModal = (p) => {
    setEditingProduct(p);
    setName(p.name);
    setCategory(p.category);
    setPrice(p.price.toString());
    setDiscount(p.discountPercentage.toString());
    setStock(p.stock.toString());
    setDescription(p.description);
    setImageUrl(p.imageUrl);
    setIsModalOpen(true);
  };

  const handleFormSubmit = (e) => {
    e.preventDefault();
    const numPrice = parseFloat(price) || 0;
    const numDiscount = parseFloat(discount) || 0;
    const numStock = parseInt(stock) || 0;
    const origPrice = numDiscount > 0 ? numPrice / (1 - numDiscount / 100) : numPrice;

    const prodObj = {
      id: editingProduct ? editingProduct.id : `p_${Date.now()}`,
      name,
      category,
      price: numPrice,
      originalPrice: origPrice,
      discountPercentage: numDiscount,
      stock: numStock,
      description,
      imageUrl,
      rating: editingProduct?.rating || 4.8,
      reviewCount: editingProduct?.reviewCount || 20,
      colors: editingProduct?.colors || ['Default'],
      sizes: editingProduct?.sizes || [],
      isFeatured: true,
      isTrending: true,
    };

    if (editingProduct) {
      updateProduct(prodObj);
    } else {
      addProduct(prodObj);
    }

    setIsModalOpen(false);
  };

  const filtered = products.filter((p) => {
    if (search && !p.name.toLowerCase().includes(search.toLowerCase())) return false;
    if (categoryFilter !== 'All' && p.category !== categoryFilter) return false;
    return true;
  });

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-black text-gray-900 dark:text-white">Product Management</h1>
          <p className="text-sm text-gray-500 mt-1">Add, edit, update stock, or remove store products</p>
        </div>
        <button
          onClick={openAddModal}
          className="px-5 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-2xl shadow-lg flex items-center space-x-2 text-sm"
        >
          <Plus size={18} />
          <span>Add New Product</span>
        </button>
      </div>

      {/* Filter Bar */}
      <div className="flex flex-col sm:flex-row items-center gap-4 bg-white dark:bg-slate-900 p-4 rounded-2xl border border-gray-100 dark:border-slate-800">
        <div className="relative flex-1 w-full">
          <input
            type="text"
            placeholder="Search product title..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="w-full pl-9 pr-4 py-2 bg-gray-50 dark:bg-slate-800 text-sm rounded-xl border border-gray-200 dark:border-slate-700 dark:text-white"
          />
          <Search className="absolute left-3 top-2.5 text-gray-400" size={16} />
        </div>

        <select
          value={categoryFilter}
          onChange={(e) => setCategoryFilter(e.target.value)}
          className="px-4 py-2 bg-gray-50 dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl text-sm font-semibold text-gray-700 dark:text-gray-200"
        >
          <option value="All">All Categories</option>
          {categories.map((c) => (
            <option key={c.id} value={c.name}>
              {c.name}
            </option>
          ))}
        </select>
      </div>

      {/* Products Table */}
      <div className="bg-white dark:bg-slate-900 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="bg-gray-50 dark:bg-slate-800/50 text-gray-500 uppercase text-[10px] tracking-wider border-b border-gray-100 dark:border-slate-800">
              <tr>
                <th className="px-6 py-4">Product</th>
                <th className="px-6 py-4">Category</th>
                <th className="px-6 py-4">Price</th>
                <th className="px-6 py-4">Stock</th>
                <th className="px-6 py-4 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100 dark:divide-slate-800">
              {filtered.map((product) => (
                <tr key={product.id} className="hover:bg-gray-50/50 dark:hover:bg-slate-800/50">
                  <td className="px-6 py-4 flex items-center space-x-3">
                    <img src={product.imageUrl} alt={product.name} className="w-10 h-10 object-cover rounded-xl bg-gray-100" />
                    <div>
                      <p className="font-bold text-gray-900 dark:text-white line-clamp-1">{product.name}</p>
                      <p className="text-xs text-gray-400">ID: {product.id}</p>
                    </div>
                  </td>
                  <td className="px-6 py-4 font-semibold text-gray-700 dark:text-gray-300">{product.category}</td>
                  <td className="px-6 py-4 font-bold text-indigo-600 dark:text-indigo-400">{formatCurrency(product.price)}</td>
                  <td className="px-6 py-4">
                    <span className={`px-2.5 py-1 text-xs font-bold rounded-full ${
                      product.stock <= 5 ? 'bg-red-100 text-red-700' : 'bg-emerald-100 text-emerald-700'
                    }`}>
                      {product.stock} units
                    </span>
                  </td>
                  <td className="px-6 py-4 text-right space-x-2">
                    <button
                      onClick={() => openEditModal(product)}
                      className="p-2 text-indigo-600 hover:bg-indigo-50 dark:hover:bg-slate-800 rounded-xl"
                    >
                      <Edit size={16} />
                    </button>
                    <button
                      onClick={() => deleteProduct(product.id)}
                      className="p-2 text-red-600 hover:bg-red-50 dark:hover:bg-slate-800 rounded-xl"
                    >
                      <Trash2 size={16} />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Modal Dialog */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-black/50 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-white dark:bg-slate-900 max-w-lg w-full p-6 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-2xl space-y-4 max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center pb-3 border-b border-gray-100 dark:border-slate-800">
              <h2 className="text-lg font-bold text-gray-900 dark:text-white">
                {editingProduct ? 'Edit Product' : 'Add New Product'}
              </h2>
              <button onClick={() => setIsModalOpen(false)} className="text-gray-400 hover:text-gray-600">
                <X size={20} />
              </button>
            </div>

            <form onSubmit={handleFormSubmit} className="space-y-3">
              <div>
                <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Product Title</label>
                <input
                  type="text"
                  required
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  className="w-full px-3.5 py-2 bg-gray-50 dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl text-sm dark:text-white"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Category</label>
                <select
                  value={category}
                  onChange={(e) => setCategory(e.target.value)}
                  className="w-full px-3.5 py-2 bg-gray-50 dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl text-sm font-semibold dark:text-white"
                >
                  {categories.map((c) => (
                    <option key={c.id} value={c.name}>
                      {c.name}
                    </option>
                  ))}
                </select>
              </div>

              <div className="grid grid-cols-3 gap-3">
                <div>
                  <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Price (₹)</label>
                  <input
                    type="number"
                    required
                    value={price}
                    onChange={(e) => setPrice(e.target.value)}
                    className="w-full px-3.5 py-2 bg-gray-50 dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl text-sm dark:text-white"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Discount (%)</label>
                  <input
                    type="number"
                    value={discount}
                    onChange={(e) => setDiscount(e.target.value)}
                    className="w-full px-3.5 py-2 bg-gray-50 dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl text-sm dark:text-white"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Stock</label>
                  <input
                    type="number"
                    required
                    value={stock}
                    onChange={(e) => setStock(e.target.value)}
                    className="w-full px-3.5 py-2 bg-gray-50 dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl text-sm dark:text-white"
                  />
                </div>
              </div>

              <div>
                <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Description</label>
                <textarea
                  rows={2}
                  required
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  className="w-full px-3.5 py-2 bg-gray-50 dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl text-sm dark:text-white"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Image URL</label>
                <input
                  type="text"
                  required
                  value={imageUrl}
                  onChange={(e) => setImageUrl(e.target.value)}
                  className="w-full px-3.5 py-2 bg-gray-50 dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl text-sm dark:text-white"
                />
              </div>

              <div className="pt-3 flex gap-3">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="flex-1 py-2.5 bg-gray-100 dark:bg-slate-800 text-gray-700 dark:text-gray-300 font-bold rounded-xl text-xs"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="flex-1 py-2.5 bg-indigo-600 text-white font-bold rounded-xl text-xs shadow-md"
                >
                  Save Product
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
