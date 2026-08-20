import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AppProvider } from './context/AppContext';
import Navbar from './components/Navbar';
import Footer from './components/Footer';

// Shop Pages
import Home from './pages/shop/Home';
import ProductList from './pages/shop/ProductList';
import ProductDetails from './pages/shop/ProductDetails';
import Cart from './pages/shop/Cart';
import Checkout from './pages/shop/Checkout';
import OrderConfirmation from './pages/shop/OrderConfirmation';
import Wishlist from './pages/shop/Wishlist';

// Auth Pages
import Login from './pages/auth/Login';
import Register from './pages/auth/Register';

// User Pages
import UserDashboard from './pages/user/UserDashboard';

// Admin Pages
import AdminLayout from './pages/admin/AdminLayout';
import AdminDashboard from './pages/admin/AdminDashboard';
import AdminAnalytics from './pages/admin/AdminAnalytics';
import AdminProducts from './pages/admin/AdminProducts';
import AdminUsers from './pages/admin/AdminUsers';
import AdminOrders from './pages/admin/AdminOrders';
import AdminProfile from './pages/admin/AdminProfile';

export default function App() {
  return (
    <AppProvider>
      <Router>
        <div className="flex flex-col min-h-screen">
          <Routes>
            {/* Admin Routes Layout */}
            <Route path="/admin" element={<AdminLayout />}>
              <Route index element={<Navigate to="dashboard" replace />} />
              <Route path="dashboard" element={<AdminDashboard />} />
              <Route path="analytics" element={<AdminAnalytics />} />
              <Route path="products" element={<AdminProducts />} />
              <Route path="users" element={<AdminUsers />} />
              <Route path="orders" element={<AdminOrders />} />
              <Route path="profile" element={<AdminProfile />} />
            </Route>

            {/* Main Customer Storefront Layout */}
            <Route
              path="*"
              element={
                <>
                  <Navbar />
                  <main className="flex-1">
                    <Routes>
                      <Route path="/" element={<Home />} />
                      <Route path="/products" element={<ProductList />} />
                      <Route path="/product/:id" element={<ProductDetails />} />
                      <Route path="/cart" element={<Cart />} />
                      <Route path="/checkout" element={<Checkout />} />
                      <Route path="/order-confirmation/:id" element={<OrderConfirmation />} />
                      <Route path="/wishlist" element={<Wishlist />} />
                      <Route path="/login" element={<Login />} />
                      <Route path="/register" element={<Register />} />
                      <Route path="/user/dashboard" element={<UserDashboard />} />
                      <Route path="/user/orders" element={<UserDashboard />} />
                      <Route path="*" element={<Navigate to="/" replace />} />
                    </Routes>
                  </main>
                  <Footer />
                </>
              }
            />
          </Routes>
        </div>
      </Router>
    </AppProvider>
  );
}
