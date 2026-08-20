import React from 'react';

export default function OrderStatusBadge({ status }) {
  const styles = {
    Delivered: 'bg-emerald-100 text-emerald-800 dark:bg-emerald-950/60 dark:text-emerald-300 border-emerald-300',
    Shipped: 'bg-purple-100 text-purple-800 dark:bg-purple-950/60 dark:text-purple-300 border-purple-300',
    Processing: 'bg-indigo-100 text-indigo-800 dark:bg-indigo-950/60 dark:text-indigo-300 border-indigo-300',
    Confirmed: 'bg-blue-100 text-blue-800 dark:bg-blue-950/60 dark:text-blue-300 border-blue-300',
    Pending: 'bg-amber-100 text-amber-800 dark:bg-amber-950/60 dark:text-amber-300 border-amber-300',
  };

  const styleClass = styles[status] || styles.Pending;

  return (
    <span className={`px-2.5 py-1 text-xs font-bold rounded-full border ${styleClass}`}>
      {status}
    </span>
  );
}
