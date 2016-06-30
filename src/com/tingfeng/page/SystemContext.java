package com.tingfeng.page;

/**
 * 用来传递对象的ThreadLocal数据
 *
 * @author tingfeng
 */
public class SystemContext {
	/**
	 * 分页的大小
	 */
	private static ThreadLocal<Integer> pageSize;
	/**
	 * 分页的起始页
	 */
	private static ThreadLocal<Integer> pageOffset;
	/**
	 * 列的排序字段
	 */
	private static ThreadLocal<String> sort;
	/**
	 * 列的排序方式
	 */
	private static ThreadLocal<String> order;

	public static Integer getPageSize() {
		return pageSize.get();
	}

	public static void setPageSize(Integer _pageSize) {
		SystemContext.pageSize.set(_pageSize);
	}

	public static Integer getPageOffset() {
		return pageOffset.get();
	}

	public static void setPageOffset(Integer _pageOffset) {
		SystemContext.pageOffset.set(_pageOffset);
	}

	public static String getSort() {
		return sort.get();
	}

	public static void setSort(String _sort) {
		SystemContext.sort.set(_sort);
	}

	public static String getOrder() {
		return order.get();
	}

	public static void setOrder(String _order) {
		SystemContext.order.set(_order);
	}

	public static void removePageSize() {
		pageSize.remove();
	}

	public static void removePageOffset() {
		pageOffset.remove();
	}

	public static void removeSort() {
		sort.remove();
	}

	public static void removeOrder() {
		order.remove();
	}
}
