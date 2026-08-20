import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { ShoppingBag, Lock, Mail, User } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export default function Register() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const { register } = useApp();
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();
    const result = register(name, email, password);
    if (result.success) {
      navigate('/user/dashboard');
    }
  };

  return (
    <div className="max-w-md mx-auto my-12 p-8 bg-white dark:bg-slate-800 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-xl space-y-6">
      <div className="text-center space-y-2">
        <div className="p-3 bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 rounded-2xl w-14 h-14 mx-auto flex items-center justify-center">
          <ShoppingBag size={28} />
        </div>
        <h2 className="text-2xl font-black text-gray-900 dark:text-white">Create Account</h2>
        <p className="text-xs text-gray-500">Sign up for a new customer account</p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Full Name</label>
          <div className="relative">
            <input
              type="text"
              required
              placeholder="e.g. Rishi Kumar"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="w-full pl-10 pr-4 py-2.5 bg-gray-50 dark:bg-slate-900 border border-gray-200 dark:border-slate-700 rounded-xl text-sm dark:text-white focus:ring-2 focus:ring-indigo-500"
            />
            <User className="absolute left-3 top-3 text-gray-400" size={18} />
          </div>
        </div>

        <div>
          <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Email Address</label>
          <div className="relative">
            <input
              type="email"
              required
              placeholder="rishi@gmail.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full pl-10 pr-4 py-2.5 bg-gray-50 dark:bg-slate-900 border border-gray-200 dark:border-slate-700 rounded-xl text-sm dark:text-white focus:ring-2 focus:ring-indigo-500"
            />
            <Mail className="absolute left-3 top-3 text-gray-400" size={18} />
          </div>
        </div>

        <div>
          <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Password</label>
          <div className="relative">
            <input
              type="password"
              required
              placeholder="Minimum 6 characters"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full pl-10 pr-4 py-2.5 bg-gray-50 dark:bg-slate-900 border border-gray-200 dark:border-slate-700 rounded-xl text-sm dark:text-white focus:ring-2 focus:ring-indigo-500"
            />
            <Lock className="absolute left-3 top-3 text-gray-400" size={18} />
          </div>
        </div>

        <button
          type="submit"
          className="w-full py-3.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl shadow-lg transition-all text-sm"
        >
          Create Customer Account
        </button>
      </form>
    </div>
  );
}
