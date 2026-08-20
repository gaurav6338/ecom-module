import React from 'react';
import { UserCheck, ShieldAlert, Trash2, Power } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export default function AdminUsers() {
  const { users, toggleUserRole, toggleUserActive, deleteUser } = useApp();

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-black text-gray-900 dark:text-white">User Management</h1>
        <p className="text-sm text-gray-500 mt-1">Manage user roles, activate/deactivate accounts, or delete users</p>
      </div>

      <div className="bg-white dark:bg-slate-900 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="bg-gray-50 dark:bg-slate-800/50 text-gray-500 uppercase text-[10px] tracking-wider border-b border-gray-100 dark:border-slate-800">
              <tr>
                <th className="px-6 py-4">User</th>
                <th className="px-6 py-4">Role</th>
                <th className="px-6 py-4">Joined Date</th>
                <th className="px-6 py-4">Status</th>
                <th className="px-6 py-4 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100 dark:divide-slate-800">
              {users.map((user) => (
                <tr key={user.id} className="hover:bg-gray-50/50 dark:hover:bg-slate-800/50">
                  <td className="px-6 py-4 flex items-center space-x-3">
                    <img src={user.avatarUrl} alt={user.name} className="w-10 h-10 object-cover rounded-full" />
                    <div>
                      <p className="font-bold text-gray-900 dark:text-white">{user.name}</p>
                      <p className="text-xs text-gray-400">{user.email}</p>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <span className={`px-2.5 py-1 text-xs font-bold rounded-full ${
                      user.role === 'admin'
                        ? 'bg-purple-100 text-purple-700 dark:bg-purple-950/60 dark:text-purple-300'
                        : 'bg-indigo-100 text-indigo-700 dark:bg-indigo-950/60 dark:text-indigo-300'
                    }`}>
                      {user.role.toUpperCase()}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-xs text-gray-500">{user.registrationDate}</td>
                  <td className="px-6 py-4">
                    <span className={`px-2.5 py-1 text-xs font-bold rounded-full ${
                      user.isActive ? 'bg-emerald-100 text-emerald-700' : 'bg-red-100 text-red-700'
                    }`}>
                      {user.isActive ? 'Active' : 'Deactivated'}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-right space-x-2">
                    <button
                      onClick={() => toggleUserRole(user.id)}
                      className="px-3 py-1.5 bg-gray-100 dark:bg-slate-800 text-xs font-bold rounded-xl text-gray-700 dark:text-gray-300 hover:bg-gray-200"
                    >
                      Toggle Role
                    </button>
                    <button
                      onClick={() => toggleUserActive(user.id)}
                      className={`p-2 rounded-xl text-white ${user.isActive ? 'bg-amber-500 hover:bg-amber-600' : 'bg-emerald-600 hover:bg-emerald-700'}`}
                      title={user.isActive ? 'Deactivate' : 'Activate'}
                    >
                      <Power size={14} />
                    </button>
                    <button
                      onClick={() => deleteUser(user.id)}
                      className="p-2 bg-red-50 text-red-600 dark:bg-red-950/60 hover:bg-red-100 rounded-xl"
                      title="Delete User"
                    >
                      <Trash2 size={14} />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
