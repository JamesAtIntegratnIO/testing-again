import React from 'react'



interface LayoutProps {
  children: React.ReactNode
}

const Layout: React.FC<LayoutProps> = ({ children }) => {
  
  

  return (
    <div className="layout">
      {/* Header */}
      <header className="header">
        <div className="container">
          <div className="header-content">
            <div className="logo-section">
              <img 
                src="https://cdn.discordapp.com/emojis/1045021806144262244.webp?size=40" 
                alt="Logo" 
                className="logo"
              />
              <h1 className="title">
                testing-again
              </h1>
            </div>
            
            

            
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="main">
        {children}
      </main>

      {/* Footer */}
      <footer className="footer">
        <div className="container">
          <div className="footer-content">
            <p>&copy; 2025 testing-again. Built with ❤️ and modern web technologies.</p>
          </div>
        </div>
      </footer>
    </div>
  )
}

export default Layout
