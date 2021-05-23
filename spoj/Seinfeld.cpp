#include<stdio.h>
#include<string.h>
#include<math.h>

int main()
{
    int i,l,t=0;
    char s[2001];
    while(1)
    {
        scanf("%s",s);
        if(s[0]=='-') break;

        int l= strlen(s);
        int stk=0,rvs=0;
        for(i=0;i<l;i++)
        {
            if(s[i]=='{') stk++;
            if(s[i]=='}'&&stk>0) stk--;
            else if( s[i]=='}'&&stk<=0 ) { rvs++; stk++; }
        }
        rvs= rvs + ceilf(stk/2.00);
        printf("%d. %d\n",++t,rvs);
        getchar();
    }
}