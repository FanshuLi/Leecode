class Solution(object):
    def longestCommonPrefix(self, strs):
        """
        :type strs: List[str]
        :rtype: str
        """
        if not strs :
            return ""
        
        for i in range(len(strs[0])):
            for string in strs[1:]:
                print (i)
                if string[i] !=strs[0][i] or i >= len(string):
                    return strs[0][:i]
       
        return strs[0]


x=longestCommonPrefix(['flower','fligh','flow'])