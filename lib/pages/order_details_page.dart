import 'package:flutter/material.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/models/my_order_model.dart';

class OrderDetailsPage extends StatelessWidget {
  final MyOrder order;

  const OrderDetailsPage({super.key, required this.order});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'out for delivery':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'preparing':
        return Icons.restaurant;
      case 'out for delivery':
        return Icons.delivery_dining;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.receipt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(order.status);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    statusColor,
                    statusColor.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStatusIcon(order.status),
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    order.status.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order #${order.orderId}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Order Information Card
            _buildSectionCard(
              context,
              title: 'Order Information',
              icon: Icons.info_outline,
              child: Column(
                children: [
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Order Date',
                    value: order.createdAt,
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    icon: Icons.payment,
                    label: 'Payment Mode',
                    value: order.paymentMode,
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    icon: Icons.receipt,
                    label: 'Payment Status',
                    value: order.paymentStatus,
                    valueColor: order.paymentStatus.toLowerCase() == 'paid'
                        ? Colors.green
                        : Colors.orange,
                  ),
                ],
              ),
            ),

            // Delivery Address Card
            _buildSectionCard(
              context,
              title: 'Delivery Address',
              icon: Icons.location_on,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 20,
                        color: AppColors.grey2,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          order.address,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 20,
                        color: AppColors.grey2,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        order.phone,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Order Items Card
            _buildSectionCard(
              context,
              title: 'Order Items',
              icon: Icons.shopping_bag_outlined,
              child: Column(
                children: [
                  ...order.products.asMap().entries.map((entry) {
                    final index = entry.key;
                    final product = entry.value;
                    final isLast = index == order.products.length - 1;

                    return Column(
                      children: [
                        _buildProductItem(context, product),
                        if (!isLast) const Divider(height: 24),
                      ],
                    );
                  }),
                ],
              ),
            ),

            // Price Breakdown Card
            _buildSectionCard(
              context,
              title: 'Price Details',
              icon: Icons.account_balance_wallet_outlined,
              child: Column(
                children: [
                  _buildPriceRow('Subtotal', order.totalAmount),
                  const SizedBox(height: 12),
                  _buildPriceRow('Delivery Charges', '0.00', color: Colors.green),
                  const SizedBox(height: 12),
                  _buildPriceRow('Tax & Fees', '0.00'),
                  const Divider(height: 24),
                  _buildPriceRow(
                    'Total Amount',
                    order.totalAmount,
                    isTotal: true,
                  ),
                ],
              ),
            ),

            // Order Remark (if exists)
            if (order.orderRemark.isNotEmpty && order.orderRemark != 'Order placed via app')
              _buildSectionCard(
                context,
                title: 'Special Instructions',
                icon: Icons.note_outlined,
                child: Text(
                  order.orderRemark,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppColors.labelSecondary,
                  ),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.grey2),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(BuildContext context, OrderProduct product) {
    final theme = Theme.of(context);
    final itemTotal = (double.parse(product.price) * product.quantity).toStringAsFixed(2);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image Placeholder
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.grey6,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.separatorOpaque),
          ),
          child: const Icon(
            Icons.fastfood,
            color: AppColors.grey3,
            size: 30,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.productName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.variantName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.labelSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.grey6,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Qty: ${product.quantity}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '₹$itemTotal',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.black : AppColors.grey2,
          ),
        ),
        Text(
          '₹$amount',
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: color ?? (isTotal ? AppColors.primary : AppColors.black),
          ),
        ),
      ],
    );
  }
}
