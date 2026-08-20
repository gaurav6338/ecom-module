import React from 'react';
import { MapPin, Plus } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export default function UserAddresses() {
  const { currentUser } = useApp();

  return (
    <div className="bg-white dark:bg-slate-800 p-6 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-sm space-y-6">
      <div className="flex justify-between items-center">
        <h2 className="text-xl font-extrabold text-gray-900 dark:text-white">Saved Shipping Addresses</h2>
      </div>

      <div className="p-4 bg-gray-50 dark:bg-slate-900 rounded-2xl border border-gray-100 dark:border-slate-700 space-y-2">
        <div className="flex items-center justify-between">
          <span className="font-bold text-sm text-gray-900 dark:text-white flex items-center space-x-1.5">
            <MapPin size={16} className="text-indigo-600" />
            <span>Home Address</span>
          </span>
          <span className="px-2 py-0.5 text-[10px] font-bold bg-emerald-100 text-emerald-800 rounded-md">
            DEFAULT
          </span>
        </div>
        <p className="text-xs font-semibold text-gray-800 dark:text-gray-200">{currentUser?.name || 'Rishi Kumar'}</p>
        <p className="text-xs text-gray-500">{currentUser?.address || '42 Lotus Heights, MG Road, Bengaluru, Karnataka - 560001'}</p>
        <p className="text-xs text-gray-400">Phone: {currentUser?.phone || '+91 98765 43210'}</p>
      </div>
    </div>
  );
}
