"use client";

import React from "react";
import { useApi } from "../../hooks/use-api";
import { LoadingSpinner } from "../ui/loading-spinner";
import { ErrorMessage } from "../ui/error-message";
import { EmptyState } from "../ui/empty-state";
import { Building2 } from "lucide-react";
import * as api from "../../lib/api-client";
import { formatCurrencyRange } from "../../utils/formatting";

/**
 * Example component demonstrating vendor platform listing with API integration
 * This component shows how to fetch and display vendors from the API
 */
export default function VendorListExample() {
  const { data: vendors, loading, error } = useApi(api.getVendors);

  if (loading) {
    return (
      <div className="p-4">
        <LoadingSpinner size="lg" text="Loading vendors..." />
      </div>
    );
  }

  if (error) {
    return (
      <div className="p-4">
        <ErrorMessage error={error} />
      </div>
    );
  }

  if (!vendors || vendors.length === 0) {
    return (
      <div className="p-4">
        <EmptyState
          icon={<Building2 className="w-12 h-12" />}
          title="No vendors available"
          description="Vendor platforms will appear here once they are added to the system."
        />
      </div>
    );
  }

  return (
    <div className="p-4">
      <h2 className="text-xl font-bold mb-4">Available Vendor Platforms</h2>
      <div className="space-y-2">
        {vendors.map((vendor) => (
          <div key={vendor.id} className="border border-light-border dark:border-dark-border p-3 rounded-lg bg-light-surface dark:bg-dark-surface">
            <div className="flex justify-between items-center">
              <div>
                <h3 className="font-semibold text-light-text dark:text-dark-text">{vendor.name}</h3>
                <p className="text-sm text-light-text-secondary dark:text-dark-text-secondary">{vendor.location}</p>
              </div>
              <div className="text-right">
                <p className="text-sm font-medium text-light-text dark:text-dark-text">
                  {formatCurrencyRange(vendor.avg_cost_per_call_min, vendor.avg_cost_per_call_max)}
                </p>
                <span className={`px-2 py-1 text-xs rounded ${
                  vendor.is_active 
                    ? "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200" 
                    : "bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300"
                }`}>
                  {vendor.is_active ? "Active" : "Inactive"}
                </span>
              </div>
            </div>
            <p className="text-sm mt-2 text-light-text-secondary dark:text-dark-text-secondary">{vendor.description}</p>
            {vendor.tags && vendor.tags.length > 0 && (
              <div className="flex gap-1 overflow-x-auto min-w-0 mt-2">
                {vendor.tags.map((tag, index) => (
                  <span key={index} className="px-2 py-1 bg-primary-100 dark:bg-primary-900 text-primary-800 dark:text-primary-200 text-xs rounded flex-shrink-0 whitespace-nowrap">
                    {tag}
                  </span>
                ))}
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
