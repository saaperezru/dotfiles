import marimo

__generated_with = "0.2.13"
app = marimo.App()


@app.cell
def __(mo):
    mo.md(
        r"""
        # Markdown samples
        ## Lists
        1. Item 1
        2. Item 2
        3. Item 3
            - Item 3a
            - Item 3b
        ##Latex equations
        See examples [here](https://ashki23.github.io/markdown-latex.html)
        You can write inline equations using the dollar sign, e.g. $x^2+y^2=0$ or write a block equation like this:

        \[
        Q^o(p) = m_op + c_o
        \]

        Or write equations like 
        
        $$\color{blue}{X \sim Normal \; (\mu,\sigma^2)}$$

        Or a full equation with split blocks

        \[
        \begin{equation}
        \begin{split}
        Q^o(p) & = Q^d(p) \\
        4p - 1000  & = 740-2p \\
        6p  & = 1740 \\
        p  & = 290
        \end{split}
        \end{equation}
        \]

        Or

        \begin{equation}
          \begin{split}
            wu &= ax+by+c\\
                    wv &= dx+ey+f\\
                    w &= gx+hy+i
          \end{split}
        \quad\leftrightarrow\quad
          \begin{split}
            ax+by+c-xug-uyh-ui &= 0\\
                    dx+ey+f-xvg-yvh-vi &= 0
          \end{split}
        \end{equation}

        ## Code samples
        For example:

        
        ```python
        norm = function(x) {
          sqrt(x%*%x)
        }
        norm(1:4)
        ```
        """
    )
    return


@app.cell
def __():
    import marimo as mo
    import matplotlib.pyplot as plt
    import numpy as np

    p = [250,260,270,280,290,300,310,320,330,340,350]
    o = [0,40,80,120,160,200,240,280,320,360,400]
    d = [240,220,200,180,160,140,120,100,80,60,40]

    fig, ax = plt.subplots(1,1)
    ax.plot(o,p, linestyle='--', marker='o', color='r')
    ax.plot(d,p, linestyle='--', marker='o', color='b')

    ax.set_xlim((0,450))
    ax.set_yticks(np.append(ax.get_yticks(),[290]))
    ax.set_ylim(ax.get_ylim())
    ax.set_xticks(np.append(ax.get_xticks(),[160]))
    ax.set_xlabel('Quantity')
    ax.set_ylabel('Price')

    ax.axvline(160, linestyle='dotted')
    ax.axhline(290, linestyle='dotted')
    return ax, d, fig, mo, np, o, p, plt


if __name__ == "__main__":
    app.run()
