import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { ShoppingBag, Lock, Mail, ShieldCheck, UserCheck } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export default function Login() {
  const [email, setEmail] = useState('rishi@gmail.com');
  const [password, setPassword] = useState('rishi123');
  const [error, setError] = useState(null);
  const { login } = useApp();
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();
    setError(null);
    const result = login(email, password);
    if (result.success) {
      if (result.user.role === 'admin') {
        navigate('/admin/dashboard');
      } else {
        navigate('/user/dashboard');
      }
    } else {
      setError(result.message);
    }
  };

  return (
    <div className="max-w-md mx-auto my-12 p-8 bg-white dark:bg-slate-800 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-xl space-y-6">
      <div className="text-center space-y-2">
        <div className="p-3 bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 rounded-2xl w-14 h-14 mx-auto flex items-center justify-center">
          <ShoppingBag size={28} />
        </div>
        <h2 className="text-2xl font-black text-gray-900 dark:text-white">Welcome Back</h2>
        <p className="text-xs text-gray-500">Sign in to your account</p>
      </div>

      {/* Quick Fill Demo Helper */}
      <div className="p-3.5 bg-indigo-50/60 dark:bg-slate-900/60 rounded-2xl border border-indigo-100 dark:border-slate-700 space-y-2">
        <p className="text-xs font-bold text-indigo-600 dark:text-indigo-400">⚡ Quick Demo Login:</p>
        <div className="flex gap-2">
          <button
            type="button"
            onClick={() => {
              setEmail('rishi@gmail.com');
              setPassword('rishi123');
            }}
            className="flex-1 py-1.5 px-2 bg-white dark:bg-slate-800 border border-indigo-200 dark:border-slate-700 text-xs font-bold rounded-xl text-indigo-600 dark:text-indigo-300 flex items-center justify-center space-x-1"
          >
            <UserCheck size={14} />
            <span>Rishi (Customer)</span>
          </button>

          <button
            type="button"
            onClick={() => {
              setEmail('admin@gmail.com');
              setPassword('admin123');
            }}
            className="flex-1 py-1.5 px-2 bg-white dark:bg-slate-800 border border-purple-200 dark:border-slate-700 text-xs font-bold rounded-xl text-purple-600 dark:text-purple-300 flex items-center justify-center space-x-1"
          >
            <ShieldCheck size={14} />
            <span>Admin</span>
          </button>
        </div>
      </div>

      {error && (
        <div className="p-3 bg-red-50 text-red-600 text-xs font-bold rounded-xl border border-red-200">
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Email Address</label>
          <div className="relative">
            <input
              type="email"
              required
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
          Sign In
        </button>
      </form>

      <p className="text-center text-xs text-gray-500">
        Don't have an account?{' '}
        <Link to="/register" className="text-indigo-600 font-bold hover:underline">
          Register here
        </Link>
      </p>
    </div>
  );
}
