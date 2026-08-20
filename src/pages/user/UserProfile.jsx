import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';

export default function UserProfile() {
  const { currentUser, updateUserProfile } = useApp();
  const [name, setName] = useState(currentUser?.name || 'Rishi Kumar');
  const [phone, setPhone] = useState(currentUser?.phone || '+91 98765 43210');
  const [address, setAddress] = useState(
    currentUser?.address || '42 Lotus Heights, MG Road, Bengaluru, Karnataka - 560001'
  );
  const [successMsg, setSuccessMsg] = useState(false);

  const handleSubmit = (e) => {
    e.preventDefault();
    updateUserProfile(currentUser.id, { name, phone, address });
    setSuccessMsg(true);
    setTimeout(() => setSuccessMsg(false), 3000);
  };

  return (
    <div className="bg-white dark:bg-slate-800 p-6 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-sm space-y-6">
      <h2 className="text-xl font-extrabold text-gray-900 dark:text-white">Edit Profile Details</h2>

      {successMsg && (
        <div className="p-3 bg-emerald-50 text-emerald-600 text-xs font-bold rounded-xl border border-emerald-200">
          Profile saved successfully!
        </div>
      )}

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Full Name</label>
          <input
            type="text"
            required
            value={name}
            onChange={(e) => setName(e.target.value)}
            className="w-full px-4 py-2.5 bg-gray-50 dark:bg-slate-900 border border-gray-200 dark:border-slate-700 rounded-xl text-sm dark:text-white"
          />
        </div>

        <div>
          <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Email Address (Primary Demo Account)</label>
          <input
            type="email"
            disabled
            value={currentUser?.email || 'rishi@gmail.com'}
            className="w-full px-4 py-2.5 bg-gray-200 dark:bg-slate-950 border border-gray-300 dark:border-slate-800 rounded-xl text-sm text-gray-500 cursor-not-allowed"
          />
        </div>

        <div>
          <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Phone Number</label>
          <input
            type="text"
            required
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            className="w-full px-4 py-2.5 bg-gray-50 dark:bg-slate-900 border border-gray-200 dark:border-slate-700 rounded-xl text-sm dark:text-white"
          />
        </div>

        <div>
          <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1">Primary Address</label>
          <textarea
            rows={3}
            required
            value={address}
            onChange={(e) => setAddress(e.target.value)}
            className="w-full px-4 py-2.5 bg-gray-50 dark:bg-slate-900 border border-gray-200 dark:border-slate-700 rounded-xl text-sm dark:text-white"
          />
        </div>

        <button
          type="submit"
          className="px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl text-sm shadow-md"
        >
          Save Profile Changes
        </button>
      </form>
    </div>
  );
}
