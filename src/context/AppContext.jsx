import React, { createContext, useContext, useState, useEffect } from 'react';
import { initialUsers, initialProducts, initialCategories, initialOrders } from '../data/initialData';

const AppContext = createContext();

export const AppProvider = ({ children }) => {
  // 1. Auth State
  const [currentUser, setCurrentUser] = useState(() => {
    const saved = localStorage.getItem('app_current_user');
    return saved ? JSON.parse(saved) : initialUsers[0]; // Seed Rishi Kumar by default
  });

  // 2. Users State
  const [users, setUsers] = useState(() => {
    const saved = localStorage.getItem('app_users');
    return saved ? JSON.parse(saved) : initialUsers;
  });

  // 3. Products State
  const [products, setProducts] = useState(() => {
    const saved = localStorage.getItem('app_products');
    return saved ? JSON.parse(saved) : initialProducts;
  });

  // 4. Cart State
  const [cart, setCart] = useState(() => {
    const saved = localStorage.getItem('app_cart');
    return saved ? JSON.parse(saved) : [];
  });

  // 5. Wishlist State
  const [wishlist, setWishlist] = useState(() => {
    const saved = localStorage.getItem('app_wishlist');
    return saved ? JSON.parse(saved) : [];
  });

  // 6. Orders State
  const [orders, setOrders] = useState(() => {
    const saved = localStorage.getItem('app_orders');
    return saved ? JSON.parse(saved) : initialOrders;
  });

  // 7. Dark Theme Mode State
  const [darkMode, setDarkMode] = useState(() => {
    const saved = localStorage.getItem('app_dark_mode');
    return saved ? JSON.parse(saved) : false;
  });

  // 8. Search & Category Filters
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [appliedCoupon, setAppliedCoupon] = useState(null);

  // Persistence Sync Effects
  useEffect(() => {
    if (currentUser) {
      localStorage.setItem('app_current_user', JSON.stringify(currentUser));
    } else {
      localStorage.removeItem('app_current_user');
    }
  }, [currentUser]);

  useEffect(() => {
    localStorage.setItem('app_users', JSON.stringify(users));
  }, [users]);

  useEffect(() => {
    localStorage.setItem('app_products', JSON.stringify(products));
  }, [products]);

  useEffect(() => {
    localStorage.setItem('app_cart', JSON.stringify(cart));
  }, [cart]);

  useEffect(() => {
    localStorage.setItem('app_wishlist', JSON.stringify(wishlist));
  }, [wishlist]);

  useEffect(() => {
    localStorage.setItem('app_orders', JSON.stringify(orders));
  }, [orders]);

  useEffect(() => {
    localStorage.setItem('app_dark_mode', JSON.stringify(darkMode));
    if (darkMode) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  }, [darkMode]);

  // Auth Handlers
  const login = (email, password) => {
    const cleanEmail = email.trim().toLowerCase();
    const foundUser = users.find(u => u.email.toLowerCase() === cleanEmail);

    if (!foundUser) {
      return { success: false, message: 'No account registered with this email address.' };
    }

    if (!foundUser.isActive) {
      return { success: false, message: 'Your account has been deactivated by an Administrator.' };
    }

    let isValidPassword = false;
    if (cleanEmail === 'rishi@gmail.com' && password === 'rishi123') isValidPassword = true;
    else if (cleanEmail === 'admin@gmail.com' && password === 'admin123') isValidPassword = true;
    else if (password.length >= 6) isValidPassword = true;

    if (!isValidPassword) {
      return { success: false, message: 'Invalid password. Please check your credentials.' };
    }

    setCurrentUser(foundUser);
    return { success: true, user: foundUser };
  };

  const register = (name, email, password) => {
    const newUser = {
      id: `user_${Date.now()}`,
      name: name.trim(),
      email: email.trim().toLowerCase(),
      phone: '+91 98000 00000',
      address: 'Add your shipping address in Profile',
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400&auto=format&fit=crop&q=80',
      role: 'user',
      registrationDate: new Date().toISOString().split('T')[0],
      isActive: true,
      orderCount: 0,
    };

    setUsers(prev => [newUser, ...prev]);
    setCurrentUser(newUser);
    return { success: true };
  };

  const logout = () => {
    setCurrentUser(null);
  };

  // Cart Actions
  const addToCart = (product, selectedSize = 'M', selectedColor = 'Default', quantity = 1) => {
    setCart(prev => {
      const existingIdx = prev.findIndex(item =>
        item.product.id === product.id &&
        item.selectedSize === selectedSize &&
        item.selectedColor === selectedColor
      );

      if (existingIdx !== -1) {
        const updated = [...prev];
        updated[existingIdx].quantity += quantity;
        updated[existingIdx].totalPrice = updated[existingIdx].quantity * product.price;
        return updated;
      } else {
        return [...prev, {
          product,
          selectedSize,
          selectedColor,
          quantity,
          totalPrice: quantity * product.price,
        }];
      }
    });
  };

  const updateCartQty = (index, delta) => {
    setCart(prev => {
      const updated = [...prev];
      updated[index].quantity += delta;
      if (updated[index].quantity <= 0) {
        updated.splice(index, 1);
      } else {
        updated[index].totalPrice = updated[index].quantity * updated[index].product.price;
      }
      return updated;
    });
  };

  const removeFromCart = (index) => {
    setCart(prev => prev.filter((_, i) => i !== index));
  };

  const clearCart = () => {
    setCart([]);
    setAppliedCoupon(null);
  };

  // Wishlist Actions
  const toggleWishlist = (productId) => {
    setWishlist(prev => {
      if (prev.includes(productId)) {
        return prev.filter(id => id !== productId);
      } else {
        return [...prev, productId];
      }
    });
  };

  // Order Actions
  const createOrder = (orderData) => {
    const newOrder = {
      id: `ORD-${Date.now().toString().substring(7)}`,
      userId: currentUser?.id || 'user_rishi_01',
      customerName: currentUser?.name || 'Rishi Kumar',
      customerEmail: currentUser?.email || 'rishi@gmail.com',
      customerPhone: currentUser?.phone || '+91 98765 43210',
      shippingAddress: currentUser?.address || '42 Lotus Heights, MG Road, Bengaluru',
      items: orderData.items,
      subtotal: orderData.subtotal,
      tax: orderData.tax,
      shippingFee: orderData.shippingFee,
      discountAmount: orderData.discountAmount,
      totalAmount: orderData.totalAmount,
      paymentMethod: orderData.paymentMethod,
      paymentStatus: orderData.paymentMethod === 'COD' ? 'Pending' : 'Paid',
      orderStatus: 'Pending',
      createdAt: new Date().toISOString(),
    };

    setOrders(prev => [newOrder, ...prev]);
    clearCart();
    return newOrder;
  };

  const updateOrderStatus = (orderId, newStatus) => {
    setOrders(prev => prev.map(o => o.id === orderId ? { ...o, orderStatus: newStatus } : o));
  };

  // Admin Product Actions
  const addProduct = (newProduct) => {
    setProducts(prev => [newProduct, ...prev]);
  };

  const updateProduct = (updatedProduct) => {
    setProducts(prev => prev.map(p => p.id === updatedProduct.id ? updatedProduct : p));
  };

  const deleteProduct = (id) => {
    setProducts(prev => prev.filter(p => p.id !== id));
  };

  // Admin User Actions
  const toggleUserRole = (id) => {
    setUsers(prev => prev.map(u => u.id === id ? { ...u, role: u.role === 'admin' ? 'user' : 'admin' } : u));
  };

  const toggleUserActive = (id) => {
    setUsers(prev => prev.map(u => u.id === id ? { ...u, isActive: !u.isActive } : u));
  };

  const deleteUser = (id) => {
    setUsers(prev => prev.filter(u => u.id !== id));
  };

  const updateUserProfile = (userId, updatedFields) => {
    setUsers(prev => prev.map(u => u.id === userId ? { ...u, ...updatedFields } : u));
    if (currentUser?.id === userId) {
      setCurrentUser(prev => ({ ...prev, ...updatedFields }));
    }
  };

  // Cart Calculations
  const cartSubtotal = cart.reduce((sum, item) => sum + item.totalPrice, 0);
  const couponDiscountPercentage = appliedCoupon === 'DISCOUNT20' ? 20 : appliedCoupon === 'WELCOME10' ? 10 : 0;
  const cartDiscountAmount = cartSubtotal * (couponDiscountPercentage / 100);
  const cartTax = (cartSubtotal - cartDiscountAmount) * 0.05;
  const cartShippingFee = cart.length === 0 ? 0 : cartSubtotal > 2000 ? 0 : 100;
  const cartTotalAmount = (cartSubtotal - cartDiscountAmount) + cartTax + cartShippingFee;

  return (
    <AppContext.Provider value={{
      currentUser,
      users,
      products,
      categories: initialCategories,
      cart,
      wishlist,
      orders,
      darkMode,
      searchQuery,
      selectedCategory,
      appliedCoupon,
      cartSubtotal,
      cartDiscountAmount,
      cartTax,
      cartShippingFee,
      cartTotalAmount,
      setDarkMode,
      setSearchQuery,
      setSelectedCategory,
      setAppliedCoupon,
      login,
      register,
      logout,
      addToCart,
      updateCartQty,
      removeFromCart,
      clearCart,
      toggleWishlist,
      createOrder,
      updateOrderStatus,
      addProduct,
      updateProduct,
      deleteProduct,
      toggleUserRole,
      toggleUserActive,
      deleteUser,
      updateUserProfile,
    }}>
      {children}
    </AppContext.Provider>
  );
};

export const useApp = () => useContext(AppContext);
