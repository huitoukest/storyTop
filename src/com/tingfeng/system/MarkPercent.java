package com.tingfeng.system;
/**
 * 评分规则,主要是评分的比例问题
 */
public class MarkPercent {
    /**
     * 总榜中综合影响指数中平均分的比例
     */
	public static double FinalAvgScorePercent=0.7;
	/**
     * 年榜中综合影响指数中平均分的比例
     */
	public static double YearAvgcorePercent=0.7;
	/**
     * 月榜中综合影响指数中平均分的比例
     */
	public static double MonthAvgScorePercent=0.7;
	
	/**
     * 总榜中综合影响指数中评分次数的比例N%,返回N的值
     */
	public static double FinalCountPercent=25;
	/**
     * 年榜中综合影响指数中评分次数的比例N%,返回N的值
     */
	public static double YearCountPercent=25;
	/**
     * 月榜中综合影响指数中评分次数的比例N%,返回N的值
     */
	public static double MonthCountPercent=25;
	
	/**
     * 总榜中综合影响指数中小说自己总分比例N%,返回N的值
     */
	public static double FinalEachSumPercent=5;
	
	/**
     * 总榜中综合影响指数中小说自己总分比例N%,返回N的值
     */
	public static double YearEachSumPercent=5;
	/**
     * 总榜中综合影响指数中小说自己总分比例N%,返回N的值
     */
	public static double MonthEachSumPercent=5;
	/**
	 * 月榜totalScore半衰减系数,月榜中的总分每满15天之后,总分乘以此系数
	 */
	public static double MonthHalfFalloffFactorScore=0.8;
	
	/**
	 * 年榜totalScore半衰减系数,年榜中的总分每满180天之后,总分乘以此系数
	 */
	public static double YearHalfFalloffFactorScore=0.8;
	
	/**
	 * 月榜MarkCount评分次数半衰减系数,月榜中的总分每满15天之后,评分次数乘以此系数
	 */
	public static double MonthHalfFalloffFactorCount=0.85;
	
	/**
	 * 年榜MarkCount评分次数半衰减系数,年榜中的总分每满180天之后,评分次数乘以此系数
	 */
	public static double YearHalfFalloffFactorCount=0.85;
	
	public MarkPercent() {
		// TODO Auto-generated constructor stub
	}

}
