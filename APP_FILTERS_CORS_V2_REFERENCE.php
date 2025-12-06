<?php
namespace App\Filters;

use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use CodeIgniter\Filters\FilterInterface;

/**
 * CORS Filter - Version 2 (Alternative if version 1 doesn't work)
 * 
 * Gunakan ini jika Cors.php yang sebelumnya masih error.
 */
class CorsV2 implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        // Get request origin
        $origin = $request->getServer('HTTP_ORIGIN') ?? '*';
        
        // Set CORS headers using response object
        $response = service('response');
        
        $response->setHeader('Access-Control-Allow-Origin', $origin)
                 ->setHeader('Access-Control-Allow-Credentials', 'true')
                 ->setHeader('Access-Control-Max-Age', '86400')
                 ->setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS, PATCH')
                 ->setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With, Accept, Origin, Access-Control-Request-Method, Access-Control-Request-Headers');
        
        // Handle preflight
        if ($request->getMethod() === 'OPTIONS') {
            return $response->setStatusCode(200);
        }

        return null;
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
        return $response;
    }
}
