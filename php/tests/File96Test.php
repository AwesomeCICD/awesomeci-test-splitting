<?php
use PHPUnit\Framework\TestCase;
use Demo\File96;

class File96Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File96::add(2, 3));
    }
}
