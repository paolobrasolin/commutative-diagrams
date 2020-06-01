if next is [
  absorb [...]

```latex
\mor S []           T; % e
\mor S [][]         T; % ee
\mor S [][][]       T; % eee
\mor S []:[]        T; % le
\mor S [][]:[]      T; % lle
\mor S [][][]:[]    T; % llle
\mor S []:[][]      T; % lee
\mor S []:[][][]    T; % leee
\mor S []:[]:[]     T; % INVALID
\mor S []:[][]:[]   T; % lele
\mor S []:[] [] []:[] T; % leele or lelle ?

\mor S [...][...]:[-->] T; % ele/lle
\mor S ["f"]["g"]:[-->] T; % ele/lle
\mor S [-->]["g"]:[-->] T; % ele/lle

\mor S f:-> T g:->, h:-> U i:->, j:->, k:-> V;
```