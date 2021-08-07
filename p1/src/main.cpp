#include <iostream>

int isPositive(int x)
{
    if (x > 0)
        return 1;
    else
        return 0;
}
int isNegative(int x)
{
    if (x < 0)
        return 1;
    else
        return 0;
}
int isSmall(int x)
{
    if (x >= -10 && x <= 10)
        return 1;
    else
        return 0;
}

int calculateAverage(int A[], int arraySize, int position)
{
    if (position == arraySize - 1)
    {
        return *(A + position);
    }
    else
    {
        int sum =
            calculateAverage(A, arraySize, position + 1)
            * (arraySize - position - 1)
            + *(A + position);
        return sum / (arraySize - position);
    }
}

long long calculateProduct(int A[], int arraySize)
{
    long long int product = 1;
    for (int i = 0; i < arraySize; i++)
    {
        product = product * A[i];
    }
    return product;
}

int countArray(int A[], int arraySize, int cntType)
{
    int i, cnt = 0;
    for (i = arraySize - 1; i >= 0; i--)
    {
        switch (cntType)
        {
        case 1:
            cnt += isPositive(A[i]);
            break;
        case -1:
            cnt += isNegative(A[i]);
            break;
        default:
            cnt += isSmall(A[i]);
            break;
        }
    }
    return cnt;
}

int main()
{
    int arraySize = 20; //determine the size of the array here
    int positive, negative, small, average;
    int Array[arraySize] = {-5,1,-3,-6,-11,100,-122,12,7,18,5,-1,1,20,3,-9,-21,-24,-11,7};
    positive = countArray(Array, arraySize, 1);
    std::cout << positive << std::endl;
    negative = countArray(Array, arraySize, -1);
    std::cout << negative << std::endl;
    small = countArray(Array, arraySize, 0);
    std::cout << small << std::endl;
    average = calculateAverage(Array, arraySize, 0);
    std::cout << average << std::endl;
    long long product;
    product = calculateProduct(Array, arraySize);
    std::cout << product << std::endl;
}
