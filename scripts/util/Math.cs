using Godot;
using System;

public static class Math
{
	public static bool isEven(int value)
	{
	  return value % 2 == 0;
	}

	public static int dec2bin(int dec)
	{
	  string binStr = "";
	  int temp;
	  int count = 31;

	  while (count >= 0)
	  {
		temp = dec >> count;

		if (Convert.ToBoolean(temp & 1))
		  binStr = binStr + "1";
		else
		  binStr = binStr + "0";

		count--;
	  }

	  return Convert.ToInt32(binStr);
	}

	public static int bin2dec(UInt32 bin)
	{
	  int dec = 0;
	  int count = 0;
	  int temp;

	  while (bin != 0)
	  {
		temp = Convert.ToInt32(bin % 10);
		bin /= 10;
		dec += temp * (int)(Mathf.Pow(2, count));
		count++;
	  }

	  return dec;
	}

	public static bool isBitEnabled(int msk, int idx)
	{
	  return Convert.ToBoolean(msk) & (1 << idx) != 0;
	}

	public static int setBit(int msk, int idx, bool enable)
	{
	  if (enable)
		return msk | (1 << idx);
	  else
		return msk & ~(1 << idx);
	}

	public static float remapToRange(float val, float inStart, float inEnd, float outStart, float outEnd)
	{
	  return inStart + (outEnd - outStart) * ((val - inStart) / (inEnd - inStart));
	}

	public static Vector2 toVec2(float val)
	{
	  return new Vector2(val, val);
	}

	public static Vector3 toVec3(float val)
	{
	  return new Vector3(val, val, val);
	}

	public static int getAngleIdx(float rad, float anglePerDir = Mathf.Tau / 8)
	{
	  float angleStep = Mathf.Stepify(rad, anglePerDir);
	  angleStep = Mathf.PosMod(angleStep, Mathf.Tau);

	  return (int)(angleStep / anglePerDir);
	}
}
